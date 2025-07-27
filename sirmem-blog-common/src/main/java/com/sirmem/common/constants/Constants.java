package com.sirmem.common.constants;

import lombok.AllArgsConstructor;
import lombok.Getter;

public class Constants {

    public final static String SPLIT = ",";

    @Getter
    @AllArgsConstructor
    public enum ResponseCode {
        // 直接使用 HTTP 状态码
        SUCCESS(200, "操作成功"),
        BAD_REQUEST(400, "非法参数"),
        UNAUTHORIZED(401, "认证失败或Token无效"),
        FORBIDDEN(403, "无权访问"),
        NOT_FOUND(404, "请求资源不存在"),
        INTERNAL_SERVER_ERROR(500, "服务器内部错误，请联系管理员");

        private final int code;
        private final String message;
    }
    
}
