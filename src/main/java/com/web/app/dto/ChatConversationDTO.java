package com.web.app.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ChatConversationDTO {
    private String conversationKey;
    private Integer customerId;
    private String sessionGuestId;
    private String customerName;
    private String customerPhone;
    private String customerEmail;
    private String lastMessage;
    private String lastTime;
    private Integer unreadCount;
}
