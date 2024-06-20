assume cs:code

code segment

              ;-----------------------------------------------
              ;将do0 0号中断处理程序装载到0000:200H中
              ;-----------------------------------------------
 start:       mov ax, cs
              mov ds, ax

              mov si, offset do0                    ;设置源内存单元地址

              mov ax, 0000H
              mov es, ax

              mov di, 0200H                        ;设置目标内存单元地址0000:0200H
              mov cx, offset do0end-offset do0     ;设置传输的长度
              cld                                  ;传输方向为正，即si和di增加
              rep movsb                            ;把 ds:si 所指地址的一个字节搬移到 es:di 所指的地址上
              ;-----------------------------------------------
              ;	设置中断向量表,将0号中断向量设置为0000:0200H
              ;-----------------------------------------------

              mov ax, 0000H
              mov es, ax
              mov word ptr es:[0*4], 0200H       ;将do0的偏移地址200H存放在0000:0000字单元中
              mov word ptr es:[0*4+2], 0000H     ;将do0的段地址0存放在0000:0002字单元中
              
              mov ax, 4c00H
              int 21H

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;	程序名称：do0  0号中断处理程序，被装载到0000:200H
;   功能：在屏幕中央显示字符串，显示“除法溢出”
;   入口参数：无
;   返回值：无
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 

       do0:   jmp short do0start
              db 'divide error!'

  do0start:   mov ax, cs
              mov ds, ax
              mov si, 0202H              ;设置ds:si指向字符串
              
              mov ax, 0b800H
              mov es, ax
              mov di, 12*160+36*2        ;设置es:di指向显存，（屏幕中央）
             
              mov cx, 13                 ;字符串长度13

         s:   mov al, [si]
              mov es:[di], al 
              inc si
              add di, 2                 ;显存2个字节代表一个字，其中奇数代表字符
              loop s

 
              mov ax, 4c00H
              int 21H

   do0end:    nop

code ends
end start