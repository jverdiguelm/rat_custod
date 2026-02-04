.class public Lio/socket/engineio/client/transports/PollingXHR;
.super Lio/socket/engineio/client/transports/Polling;
.source "PollingXHR.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lio/socket/engineio/client/transports/PollingXHR$Request;
    }
.end annotation


# static fields
.field private static LOGGABLE_FINE:Z

.field private static final logger:Ljava/util/logging/Logger;


# direct methods
.method static constructor <clinit>()V
    .locals 2

    .line 28
    const-class v0, Lio/socket/engineio/client/transports/PollingXHR;

    invoke-virtual {v0}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Ljava/util/logging/Logger;->getLogger(Ljava/lang/String;)Ljava/util/logging/Logger;

    move-result-object v0

    sput-object v0, Lio/socket/engineio/client/transports/PollingXHR;->logger:Ljava/util/logging/Logger;

    .line 30
    sget-object v1, Ljava/util/logging/Level;->FINE:Ljava/util/logging/Level;

    invoke-virtual {v0, v1}, Ljava/util/logging/Logger;->isLoggable(Ljava/util/logging/Level;)Z

    move-result v0

    sput-boolean v0, Lio/socket/engineio/client/transports/PollingXHR;->LOGGABLE_FINE:Z

    return-void
.end method

.method public constructor <init>(Lio/socket/engineio/client/Transport$Options;)V
    .locals 0

    .line 33
    invoke-direct {p0, p1}, Lio/socket/engineio/client/transports/Polling;-><init>(Lio/socket/engineio/client/Transport$Options;)V

    return-void
.end method

.method static synthetic access$000(Lio/socket/engineio/client/transports/PollingXHR;Ljava/lang/String;Ljava/lang/Exception;)Lio/socket/engineio/client/Transport;
    .locals 0

    .line 26
    invoke-virtual {p0, p1, p2}, Lio/socket/engineio/client/transports/PollingXHR;->onError(Ljava/lang/String;Ljava/lang/Exception;)Lio/socket/engineio/client/Transport;

    move-result-object p0

    return-object p0
.end method

.method static synthetic access$100(Lio/socket/engineio/client/transports/PollingXHR;Ljava/lang/String;Ljava/lang/Exception;)Lio/socket/engineio/client/Transport;
    .locals 0

    .line 26
    invoke-virtual {p0, p1, p2}, Lio/socket/engineio/client/transports/PollingXHR;->onError(Ljava/lang/String;Ljava/lang/Exception;)Lio/socket/engineio/client/Transport;

    move-result-object p0

    return-object p0
.end method

.method static synthetic access$200()Z
    .locals 1

    .line 26
    sget-boolean v0, Lio/socket/engineio/client/transports/PollingXHR;->LOGGABLE_FINE:Z

    return v0
.end method

.method static synthetic access$300()Ljava/util/logging/Logger;
    .locals 1

    .line 26
    sget-object v0, Lio/socket/engineio/client/transports/PollingXHR;->logger:Ljava/util/logging/Logger;

    return-object v0
.end method


# virtual methods
.method protected doPoll()V
    .locals 3

    .line 107
    sget-object v0, Lio/socket/engineio/client/transports/PollingXHR;->logger:Ljava/util/logging/Logger;

    const-string v1, "xhr poll"

    invoke-virtual {v0, v1}, Ljava/util/logging/Logger;->fine(Ljava/lang/String;)V

    .line 108
    invoke-virtual {p0}, Lio/socket/engineio/client/transports/PollingXHR;->request()Lio/socket/engineio/client/transports/PollingXHR$Request;

    move-result-object v0

    .line 110
    new-instance v1, Lio/socket/engineio/client/transports/PollingXHR$5;

    invoke-direct {v1, p0, p0}, Lio/socket/engineio/client/transports/PollingXHR$5;-><init>(Lio/socket/engineio/client/transports/PollingXHR;Lio/socket/engineio/client/transports/PollingXHR;)V

    const-string v2, "data"

    invoke-virtual {v0, v2, v1}, Lio/socket/engineio/client/transports/PollingXHR$Request;->on(Ljava/lang/String;Lio/socket/emitter/Emitter$Listener;)Lio/socket/emitter/Emitter;

    .line 122
    new-instance v1, Lio/socket/engineio/client/transports/PollingXHR$6;

    invoke-direct {v1, p0, p0}, Lio/socket/engineio/client/transports/PollingXHR$6;-><init>(Lio/socket/engineio/client/transports/PollingXHR;Lio/socket/engineio/client/transports/PollingXHR;)V

    const-string v2, "error"

    invoke-virtual {v0, v2, v1}, Lio/socket/engineio/client/transports/PollingXHR$Request;->on(Ljava/lang/String;Lio/socket/emitter/Emitter$Listener;)Lio/socket/emitter/Emitter;

    .line 134
    invoke-virtual {v0}, Lio/socket/engineio/client/transports/PollingXHR$Request;->create()V

    return-void
.end method

.method protected doWrite(Ljava/lang/String;Ljava/lang/Runnable;)V
    .locals 2

    .line 73
    new-instance v0, Lio/socket/engineio/client/transports/PollingXHR$Request$Options;

    invoke-direct {v0}, Lio/socket/engineio/client/transports/PollingXHR$Request$Options;-><init>()V

    const-string v1, "POST"

    .line 74
    iput-object v1, v0, Lio/socket/engineio/client/transports/PollingXHR$Request$Options;->method:Ljava/lang/String;

    .line 75
    iput-object p1, v0, Lio/socket/engineio/client/transports/PollingXHR$Request$Options;->data:Ljava/lang/String;

    .line 76
    iget-object p1, p0, Lio/socket/engineio/client/transports/PollingXHR;->extraHeaders:Ljava/util/Map;

    iput-object p1, v0, Lio/socket/engineio/client/transports/PollingXHR$Request$Options;->extraHeaders:Ljava/util/Map;

    .line 77
    invoke-virtual {p0, v0}, Lio/socket/engineio/client/transports/PollingXHR;->request(Lio/socket/engineio/client/transports/PollingXHR$Request$Options;)Lio/socket/engineio/client/transports/PollingXHR$Request;

    move-result-object p1

    .line 79
    new-instance v0, Lio/socket/engineio/client/transports/PollingXHR$3;

    invoke-direct {v0, p0, p2}, Lio/socket/engineio/client/transports/PollingXHR$3;-><init>(Lio/socket/engineio/client/transports/PollingXHR;Ljava/lang/Runnable;)V

    const-string p2, "success"

    invoke-virtual {p1, p2, v0}, Lio/socket/engineio/client/transports/PollingXHR$Request;->on(Ljava/lang/String;Lio/socket/emitter/Emitter$Listener;)Lio/socket/emitter/Emitter;

    .line 90
    new-instance p2, Lio/socket/engineio/client/transports/PollingXHR$4;

    invoke-direct {p2, p0, p0}, Lio/socket/engineio/client/transports/PollingXHR$4;-><init>(Lio/socket/engineio/client/transports/PollingXHR;Lio/socket/engineio/client/transports/PollingXHR;)V

    const-string v0, "error"

    invoke-virtual {p1, v0, p2}, Lio/socket/engineio/client/transports/PollingXHR$Request;->on(Ljava/lang/String;Lio/socket/emitter/Emitter$Listener;)Lio/socket/emitter/Emitter;

    .line 102
    invoke-virtual {p1}, Lio/socket/engineio/client/transports/PollingXHR$Request;->create()V

    return-void
.end method

.method protected request()Lio/socket/engineio/client/transports/PollingXHR$Request;
    .locals 1

    const/4 v0, 0x0

    .line 37
    invoke-virtual {p0, v0}, Lio/socket/engineio/client/transports/PollingXHR;->request(Lio/socket/engineio/client/transports/PollingXHR$Request$Options;)Lio/socket/engineio/client/transports/PollingXHR$Request;

    move-result-object v0

    return-object v0
.end method

.method protected request(Lio/socket/engineio/client/transports/PollingXHR$Request$Options;)Lio/socket/engineio/client/transports/PollingXHR$Request;
    .locals 3

    if-nez p1, :cond_0

    .line 42
    new-instance p1, Lio/socket/engineio/client/transports/PollingXHR$Request$Options;

    invoke-direct {p1}, Lio/socket/engineio/client/transports/PollingXHR$Request$Options;-><init>()V

    .line 44
    :cond_0
    invoke-virtual {p0}, Lio/socket/engineio/client/transports/PollingXHR;->uri()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p1, Lio/socket/engineio/client/transports/PollingXHR$Request$Options;->uri:Ljava/lang/String;

    .line 45
    iget-object v0, p0, Lio/socket/engineio/client/transports/PollingXHR;->callFactory:Lokhttp3/Call$Factory;

    iput-object v0, p1, Lio/socket/engineio/client/transports/PollingXHR$Request$Options;->callFactory:Lokhttp3/Call$Factory;

    .line 46
    iget-object v0, p0, Lio/socket/engineio/client/transports/PollingXHR;->extraHeaders:Ljava/util/Map;

    iput-object v0, p1, Lio/socket/engineio/client/transports/PollingXHR$Request$Options;->extraHeaders:Ljava/util/Map;

    .line 48
    new-instance v0, Lio/socket/engineio/client/transports/PollingXHR$Request;

    invoke-direct {v0, p1}, Lio/socket/engineio/client/transports/PollingXHR$Request;-><init>(Lio/socket/engineio/client/transports/PollingXHR$Request$Options;)V

    .line 51
    new-instance p1, Lio/socket/engineio/client/transports/PollingXHR$2;

    invoke-direct {p1, p0, p0}, Lio/socket/engineio/client/transports/PollingXHR$2;-><init>(Lio/socket/engineio/client/transports/PollingXHR;Lio/socket/engineio/client/transports/PollingXHR;)V

    const-string v1, "requestHeaders"

    invoke-virtual {v0, v1, p1}, Lio/socket/engineio/client/transports/PollingXHR$Request;->on(Ljava/lang/String;Lio/socket/emitter/Emitter$Listener;)Lio/socket/emitter/Emitter;

    move-result-object p1

    new-instance v1, Lio/socket/engineio/client/transports/PollingXHR$1;

    invoke-direct {v1, p0, p0}, Lio/socket/engineio/client/transports/PollingXHR$1;-><init>(Lio/socket/engineio/client/transports/PollingXHR;Lio/socket/engineio/client/transports/PollingXHR;)V

    const-string v2, "responseHeaders"

    .line 57
    invoke-virtual {p1, v2, v1}, Lio/socket/emitter/Emitter;->on(Ljava/lang/String;Lio/socket/emitter/Emitter$Listener;)Lio/socket/emitter/Emitter;

    return-object v0
.end method
