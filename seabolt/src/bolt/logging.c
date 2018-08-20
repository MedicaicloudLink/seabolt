/*
 * Copyright (c) 2002-2018 "Neo4j,"
 * Neo4j Sweden AB [http://neo4j.com]
 *
 * This file is part of Neo4j.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */


#include <stdarg.h>
#include <stdlib.h>

#include "bolt/logging.h"
#include "bolt/mem.h"

#include "protocol/v1.h"

struct BoltLog* BoltLog_create()
{
    struct BoltLog* log = (struct BoltLog*) BoltMem_allocate(sizeof(struct BoltLog));
    log->state = 0;
    log->debug_logger = NULL;
    log->info_logger = NULL;
    log->warning_logger = NULL;
    log->error_logger = NULL;
    log->debug_enabled = 0;
    log->info_enabled = 0;
    log->warning_enabled = 0;
    log->error_enabled = 0;
    return log;
}

void BoltLog_destroy(struct BoltLog* log)
{
    BoltMem_deallocate(log, sizeof(struct BoltLog));
}

void _perform_log_call(log_func func, int state, const char* format, va_list args)
{
    int size = 512*sizeof(char);
    char* message_fmt = BoltMem_allocate(size);
    while (1) {
        int written = vsnprintf(message_fmt, size, format, args);
        if (written<size) {
            break;
        }
        BoltMem_deallocate(message_fmt, size);
        size = size*2;
        message_fmt = BoltMem_allocate(size);
    }

    func(state, message_fmt);

    BoltMem_deallocate(message_fmt, size);
}

void BoltLog_error(const struct BoltLog* log, const char* format, ...)
{
    if (log!=NULL && log->error_enabled) {
        va_list args;
        va_start(args, format);
        _perform_log_call(log->error_logger, log->state, format, args);
        va_end(args);
    }
}

void BoltLog_warning(const struct BoltLog* log, const char* format, ...)
{
    if (log!=NULL && log->warning_enabled) {
        va_list args;
        va_start(args, format);
        _perform_log_call(log->warning_logger, log->state, format, args);
        va_end(args);
    }
}

void BoltLog_info(const struct BoltLog* log, const char* format, ...)
{
    if (log!=NULL && log->info_enabled) {
        va_list args;
        va_start(args, format);
        _perform_log_call(log->info_logger, log->state, format, args);
        va_end(args);

    }
}

void BoltLog_debug(const struct BoltLog* log, const char* format, ...)
{
    if (log!=NULL && log->debug_enabled) {
        va_list args;
        va_start(args, format);
        _perform_log_call(log->debug_logger, log->state, format, args);
        va_end(args);
    }
}

void
BoltLog_value(const struct BoltLog* log, const char* format, struct BoltValue* value, int32_t protocol_version)
{
    if (log->debug_enabled) {
        struct StringBuilder* builder = StringBuilder_create();
        BoltValue_write(builder, value, protocol_version);
        BoltLog_debug(log, format, StringBuilder_get_string(builder));
        StringBuilder_destroy(builder);
    }
}

void BoltLog_message(const struct BoltLog* log, const char* peer, bolt_request_t request_id, int16_t code,
        struct BoltValue* fields, int32_t protocol_version)
{
    if (log->debug_enabled) {
        const char* message_name = NULL;
        switch (protocol_version) {
        case 1:
        case 2: {
            message_name = BoltProtocolV1_message_name(code);
            break;
        }
        }

        struct StringBuilder* builder = StringBuilder_create();
        BoltValue_write(builder, fields, protocol_version);
        BoltLog_debug(log, "%s[%" PRIu64 "] %s %s", peer, request_id, message_name==NULL ? "?" : message_name,
                StringBuilder_get_string(builder));
        StringBuilder_destroy(builder);
    }
}
