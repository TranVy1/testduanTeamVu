package com.web.app.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ChatMessageDTO {
    private Integer id;
    private Integer customerId;
    private String sessionGuestId;
    private String senderRole; // CUSTOMER, ADMIN, BOT
    private String senderName;
    private String content;
    private String time;
    private Boolean read;
}
