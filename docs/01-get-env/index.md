# 【c】跨平台c系统环境变量获取库


一个简单的，跨平台c环境变量获取库.

<!--more-->

## 简述
c语言获取环境的变量的方式，window和linux都是相同的方式，通常使用getenv接口进行获取环境变量，但是往往我们获取环境变量的时候，常需要做一定的判断:
- 环境变量未获取到，提示错误（assert），终止程序运行。
- 环境变量未获取到，使用自定义默认值，初始化环境变量。
- bool类型环境变量设置为 yes，true，y，t 等等，能直接转换为bool类型


## 源代码
```c
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <string.h>

typedef enum {
    ENV_FALSE = 0,
    ENV_TRUE = 1
} env_bool_t;

#ifdef _WIN32
#define strcasecmp(s1, s2) stricmp(s1, s2)
#endif

static env_bool_t zstr(const char *s)
{
    return (s == NULL || s[0] == '\0') ? ENV_TRUE : ENV_FALSE;
}

static const char* env_get_string_imp(const char* key, const char* default_value, env_bool_t must_get)
{
    char* val = getenv(key);
    if (!zstr(val)) {
        return val;
    }

    if (must_get) {
        printf("env key \"%s\" does not find!\n", key);
        assert(NULL);
    } else {
        return default_value;
    }
}

static const int env_get_int_imp(const char* key, const int default_value, env_bool_t must_get)
{
    const char* val = getenv(key);
    if (!zstr(val)) {
        return atoi(val);
    }

    if (must_get) {
        printf("env key \"%s\" does not find!\n", key);
        assert(NULL);
    } else {
        return default_value;
    }
}

static env_bool_t env_true(const char *s)
{
    if (zstr(s)) {
        return ENV_FALSE;
    }

    if (!strcasecmp(s, "yes") ||
        !strcasecmp(s, "true") ||
        !strcasecmp(s, "y") ||
        !strcasecmp(s, "t") ||
        !strcasecmp(s, "1") ||
        !strcasecmp(s, "enabled") ||
        !strcasecmp(s, "active") ||
        !strcasecmp(s, "allow") ||
        !strcasecmp(s, "on")) {
        return ENV_TRUE;
    }

    return ENV_FALSE;
}

static const env_bool_t env_get_bool_imp(const char* key, const env_bool_t default_value, env_bool_t must_get)
{
    const char* val = getenv(key);
    if (!zstr(val)) {
        return env_true(val);
    }

    if (must_get) {
        printf("env key \"%s\" does not find!\n", key);
        assert(NULL);
    } else {
        return default_value;
    }

}

const char* env_get_string(const char* key, const char* default_value)
{
    return env_get_string_imp(key, default_value, ENV_FALSE);
}

const int env_get_int(const char* key, const int default_value)
{
    return env_get_int_imp(key, default_value, ENV_FALSE);
}

const env_bool_t env_get_bool(const char* key, const env_bool_t default_value)
{
    return env_get_bool_imp(key, default_value, ENV_FALSE);
}

const char* env_mustget_string(const char* key)
{
    return env_get_string_imp(key, NULL, ENV_TRUE);
}

const int env_mustget_int(const char* key)
{
    return env_get_int_imp(key, 0, ENV_TRUE);
}

const env_bool_t env_mustget_bool(const char* key)
{
    return env_get_bool_imp(key, ENV_FALSE, ENV_TRUE);
}
```

## 关键接口说明
### 自定义默认值获取接口
`const char* env_get_string(const char* key, const char* default_value)`
### 获取失败assert接口
`const char* env_mustget_string(const char* key)`
### 获取bool类型接口
`const env_bool_t env_mustget_bool(const char* key)`

## Github地址

- [https://github.com/CoolLiuzw/c-env](https://github.com/CoolLiuzw/c-env)
