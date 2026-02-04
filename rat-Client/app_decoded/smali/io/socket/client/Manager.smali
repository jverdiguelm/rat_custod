.class public Lio/socket/client/Manager;
.super Lio/socket/emitter/Emitter;
.source "Manager.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lio/socket/client/Manager$Options;,
        Lio/socket/client/Manager$Engine;,
        Lio/socket/client/Manager$OpenCallback;,
        Lio/socket/client/Manager$ReadyState;
    }
.end annotation


# static fields
.field public static final EVENT_CLOSE:Ljava/lang/String; = "close"

.field public static final EVENT_ERROR:Ljava/lang/String; = "error"

.field public static final EVENT_OPEN:Ljava/lang/String; = "open"

.field public static final EVENT_PACKET:Ljava/lang/String; = "packet"

.field public static final EVENT_RECONNECT:Ljava/lang/String; = "reconnect"

.field public static final EVENT_RECONNECT_ATTEMPT:Ljava/lang/String; = "reconnect_attempt"

.field public static final EVENT_RECONNECT_ERROR:Ljava/lang/String; = "reconnect_error"

.field public static final EVENT_RECONNECT_FAILED:Ljava/lang/String; = "reconnect_failed"

.field public static final EVENT_TRANSPORT:Ljava/lang/String; = "transport"

.field static defaultCallFactory:Lokhttp3/Call$Factory;

.field static defaultWebSocketFactory:Lokhttp3/WebSocket$Factory;

.field private static final logger:Ljava/util/logging/Logger;


# instance fields
.field private _randomizationFactor:D

.field private _reconnection:Z

.field private _reconnectionAttempts:I

.field private _reconnectionDelay:J

.field private _reconnectionDelayMax:J

.field private _timeout:J

.field private backoff:Lio/socket/backo/Backoff;

.field private decoder:Lio/socket/parser/Parser$Decoder;

.field private encoder:Lio/socket/parser/Parser$Encoder;

.field private encoding:Z

.field engine:Lio/socket/engineio/client/Socket;

.field nsps:Ljava/util/concurrent/ConcurrentHashMap;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/concurrent/ConcurrentHashMap<",
            "Ljava/lang/String;",
            "Lio/socket/client/Socket;",
            ">;"
        }
    .end annotation
.end field

.field private opts:Lio/socket/client/Manager$Options;

.field private packetBuffer:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Lio/socket/parser/Packet;",
            ">;"
        }
    .end annotation
.end field

.field readyState:Lio/socket/client/Manager$ReadyState;

.field private reconnecting:Z

.field private skipReconnect:Z

.field private subs:Ljava/util/Queue;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Queue<",
            "Lio/socket/client/On$Handle;",
            ">;"
        }
    .end annotation
.end field

.field private uri:Ljava/net/URI;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 24
    const-class v0, Lio/socket/client/Manager;

    invoke-virtual {v0}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Ljava/util/logging/Logger;->getLogger(Ljava/lang/String;)Ljava/util/logging/Logger;

    move-result-object v0

    sput-object v0, Lio/socket/client/Manager;->logger:Ljava/util/logging/Logger;

    return-void
.end method

.method public constructor <init>()V
    .locals 1

    const/4 v0, 0x0

    .line 92
    invoke-direct {p0, v0, v0}, Lio/socket/client/Manager;-><init>(Ljava/net/URI;Lio/socket/client/Manager$Options;)V

    return-void
.end method

.method public constructor <init>(Lio/socket/client/Manager$Options;)V
    .locals 1

    const/4 v0, 0x0

    .line 100
    invoke-direct {p0, v0, p1}, Lio/socket/client/Manager;-><init>(Ljava/net/URI;Lio/socket/client/Manager$Options;)V

    return-void
.end method

.method public constructor <init>(Ljava/net/URI;)V
    .locals 1

    const/4 v0, 0x0

    .line 96
    invoke-direct {p0, p1, v0}, Lio/socket/client/Manager;-><init>(Ljava/net/URI;Lio/socket/client/Manager$Options;)V

    return-void
.end method

.method public constructor <init>(Ljava/net/URI;Lio/socket/client/Manager$Options;)V
    .locals 5

    .line 103
    invoke-direct {p0}, Lio/socket/emitter/Emitter;-><init>()V

    if-nez p2, :cond_0

    .line 105
    new-instance p2, Lio/socket/client/Manager$Options;

    invoke-direct {p2}, Lio/socket/client/Manager$Options;-><init>()V

    .line 107
    :cond_0
    iget-object v0, p2, Lio/socket/client/Manager$Options;->path:Ljava/lang/String;

    if-nez v0, :cond_1

    const-string v0, "/socket.io"

    .line 108
    iput-object v0, p2, Lio/socket/client/Manager$Options;->path:Ljava/lang/String;

    .line 110
    :cond_1
    iget-object v0, p2, Lio/socket/client/Manager$Options;->webSocketFactory:Lokhttp3/WebSocket$Factory;

    if-nez v0, :cond_2

    .line 111
    sget-object v0, Lio/socket/client/Manager;->defaultWebSocketFactory:Lokhttp3/WebSocket$Factory;

    iput-object v0, p2, Lio/socket/client/Manager$Options;->webSocketFactory:Lokhttp3/WebSocket$Factory;

    .line 113
    :cond_2
    iget-object v0, p2, Lio/socket/client/Manager$Options;->callFactory:Lokhttp3/Call$Factory;

    if-nez v0, :cond_3

    .line 114
    sget-object v0, Lio/socket/client/Manager;->defaultCallFactory:Lokhttp3/Call$Factory;

    iput-object v0, p2, Lio/socket/client/Manager$Options;->callFactory:Lokhttp3/Call$Factory;

    .line 116
    :cond_3
    iput-object p2, p0, Lio/socket/client/Manager;->opts:Lio/socket/client/Manager$Options;

    .line 117
    new-instance v0, Ljava/util/concurrent/ConcurrentHashMap;

    invoke-direct {v0}, Ljava/util/concurrent/ConcurrentHashMap;-><init>()V

    iput-object v0, p0, Lio/socket/client/Manager;->nsps:Ljava/util/concurrent/ConcurrentHashMap;

    .line 118
    new-instance v0, Ljava/util/LinkedList;

    invoke-direct {v0}, Ljava/util/LinkedList;-><init>()V

    iput-object v0, p0, Lio/socket/client/Manager;->subs:Ljava/util/Queue;

    .line 119
    iget-boolean v0, p2, Lio/socket/client/Manager$Options;->reconnection:Z

    invoke-virtual {p0, v0}, Lio/socket/client/Manager;->reconnection(Z)Lio/socket/client/Manager;

    .line 120
    iget v0, p2, Lio/socket/client/Manager$Options;->reconnectionAttempts:I

    if-eqz v0, :cond_4

    iget v0, p2, Lio/socket/client/Manager$Options;->reconnectionAttempts:I

    goto :goto_0

    :cond_4
    const v0, 0x7fffffff

    :goto_0
    invoke-virtual {p0, v0}, Lio/socket/client/Manager;->reconnectionAttempts(I)Lio/socket/client/Manager;

    .line 121
    iget-wide v0, p2, Lio/socket/client/Manager$Options;->reconnectionDelay:J

    const-wide/16 v2, 0x0

    cmp-long v4, v0, v2

    if-eqz v4, :cond_5

    iget-wide v0, p2, Lio/socket/client/Manager$Options;->reconnectionDelay:J

    goto :goto_1

    :cond_5
    const-wide/16 v0, 0x3e8

    :goto_1
    invoke-virtual {p0, v0, v1}, Lio/socket/client/Manager;->reconnectionDelay(J)Lio/socket/client/Manager;

    .line 122
    iget-wide v0, p2, Lio/socket/client/Manager$Options;->reconnectionDelayMax:J

    cmp-long v4, v0, v2

    if-eqz v4, :cond_6

    iget-wide v0, p2, Lio/socket/client/Manager$Options;->reconnectionDelayMax:J

    goto :goto_2

    :cond_6
    const-wide/16 v0, 0x1388

    :goto_2
    invoke-virtual {p0, v0, v1}, Lio/socket/client/Manager;->reconnectionDelayMax(J)Lio/socket/client/Manager;

    .line 123
    iget-wide v0, p2, Lio/socket/client/Manager$Options;->randomizationFactor:D

    const-wide/16 v2, 0x0

    cmpl-double v4, v0, v2

    if-eqz v4, :cond_7

    iget-wide v0, p2, Lio/socket/client/Manager$Options;->randomizationFactor:D

    goto :goto_3

    :cond_7
    const-wide/high16 v0, 0x3fe0000000000000L    # 0.5

    :goto_3
    invoke-virtual {p0, v0, v1}, Lio/socket/client/Manager;->randomizationFactor(D)Lio/socket/client/Manager;

    .line 124
    new-instance v0, Lio/socket/backo/Backoff;

    invoke-direct {v0}, Lio/socket/backo/Backoff;-><init>()V

    .line 125
    invoke-virtual {p0}, Lio/socket/client/Manager;->reconnectionDelay()J

    move-result-wide v1

    invoke-virtual {v0, v1, v2}, Lio/socket/backo/Backoff;->setMin(J)Lio/socket/backo/Backoff;

    move-result-object v0

    .line 126
    invoke-virtual {p0}, Lio/socket/client/Manager;->reconnectionDelayMax()J

    move-result-wide v1

    invoke-virtual {v0, v1, v2}, Lio/socket/backo/Backoff;->setMax(J)Lio/socket/backo/Backoff;

    move-result-object v0

    .line 127
    invoke-virtual {p0}, Lio/socket/client/Manager;->randomizationFactor()D

    move-result-wide v1

    invoke-virtual {v0, v1, v2}, Lio/socket/backo/Backoff;->setJitter(D)Lio/socket/backo/Backoff;

    move-result-object v0

    iput-object v0, p0, Lio/socket/client/Manager;->backoff:Lio/socket/backo/Backoff;

    .line 128
    iget-wide v0, p2, Lio/socket/client/Manager$Options;->timeout:J

    invoke-virtual {p0, v0, v1}, Lio/socket/client/Manager;->timeout(J)Lio/socket/client/Manager;

    .line 129
    sget-object v0, Lio/socket/client/Manager$ReadyState;->CLOSED:Lio/socket/client/Manager$ReadyState;

    iput-object v0, p0, Lio/socket/client/Manager;->readyState:Lio/socket/client/Manager$ReadyState;

    .line 130
    iput-object p1, p0, Lio/socket/client/Manager;->uri:Ljava/net/URI;

    const/4 p1, 0x0

    .line 131
    iput-boolean p1, p0, Lio/socket/client/Manager;->encoding:Z

    .line 132
    new-instance p1, Ljava/util/ArrayList;

    invoke-direct {p1}, Ljava/util/ArrayList;-><init>()V

    iput-object p1, p0, Lio/socket/client/Manager;->packetBuffer:Ljava/util/List;

    .line 133
    iget-object p1, p2, Lio/socket/client/Manager$Options;->encoder:Lio/socket/parser/Parser$Encoder;

    if-eqz p1, :cond_8

    iget-object p1, p2, Lio/socket/client/Manager$Options;->encoder:Lio/socket/parser/Parser$Encoder;

    goto :goto_4

    :cond_8
    new-instance p1, Lio/socket/parser/IOParser$Encoder;

    invoke-direct {p1}, Lio/socket/parser/IOParser$Encoder;-><init>()V

    :goto_4
    iput-object p1, p0, Lio/socket/client/Manager;->encoder:Lio/socket/parser/Parser$Encoder;

    .line 134
    iget-object p1, p2, Lio/socket/client/Manager$Options;->decoder:Lio/socket/parser/Parser$Decoder;

    if-eqz p1, :cond_9

    iget-object p1, p2, Lio/socket/client/Manager$Options;->decoder:Lio/socket/parser/Parser$Decoder;

    goto :goto_5

    :cond_9
    new-instance p1, Lio/socket/parser/IOParser$Decoder;

    invoke-direct {p1}, Lio/socket/parser/IOParser$Decoder;-><init>()V

    :goto_5
    iput-object p1, p0, Lio/socket/client/Manager;->decoder:Lio/socket/parser/Parser$Decoder;

    return-void
.end method

.method static synthetic access$000()Ljava/util/logging/Logger;
    .locals 1

    .line 22
    sget-object v0, Lio/socket/client/Manager;->logger:Ljava/util/logging/Logger;

    return-object v0
.end method

.method static synthetic access$100(Lio/socket/client/Manager;)Ljava/net/URI;
    .locals 0

    .line 22
    iget-object p0, p0, Lio/socket/client/Manager;->uri:Ljava/net/URI;

    return-object p0
.end method

.method static synthetic access$1000(Lio/socket/client/Manager;Ljava/lang/Exception;)V
    .locals 0

    .line 22
    invoke-direct {p0, p1}, Lio/socket/client/Manager;->onerror(Ljava/lang/Exception;)V

    return-void
.end method

.method static synthetic access$1100(Lio/socket/client/Manager;Ljava/lang/String;)V
    .locals 0

    .line 22
    invoke-direct {p0, p1}, Lio/socket/client/Manager;->onclose(Ljava/lang/String;)V

    return-void
.end method

.method static synthetic access$1200(Lio/socket/client/Manager;Lio/socket/parser/Packet;)V
    .locals 0

    .line 22
    invoke-direct {p0, p1}, Lio/socket/client/Manager;->ondecoded(Lio/socket/parser/Packet;)V

    return-void
.end method

.method static synthetic access$1302(Lio/socket/client/Manager;Z)Z
    .locals 0

    .line 22
    iput-boolean p1, p0, Lio/socket/client/Manager;->encoding:Z

    return p1
.end method

.method static synthetic access$1400(Lio/socket/client/Manager;)V
    .locals 0

    .line 22
    invoke-direct {p0}, Lio/socket/client/Manager;->processPacketQueue()V

    return-void
.end method

.method static synthetic access$1500(Lio/socket/client/Manager;)Lio/socket/backo/Backoff;
    .locals 0

    .line 22
    iget-object p0, p0, Lio/socket/client/Manager;->backoff:Lio/socket/backo/Backoff;

    return-object p0
.end method

.method static synthetic access$1602(Lio/socket/client/Manager;Z)Z
    .locals 0

    .line 22
    iput-boolean p1, p0, Lio/socket/client/Manager;->reconnecting:Z

    return p1
.end method

.method static synthetic access$1700(Lio/socket/client/Manager;)V
    .locals 0

    .line 22
    invoke-direct {p0}, Lio/socket/client/Manager;->reconnect()V

    return-void
.end method

.method static synthetic access$1800(Lio/socket/client/Manager;)V
    .locals 0

    .line 22
    invoke-direct {p0}, Lio/socket/client/Manager;->onreconnect()V

    return-void
.end method

.method static synthetic access$200(Lio/socket/client/Manager;)Lio/socket/client/Manager$Options;
    .locals 0

    .line 22
    iget-object p0, p0, Lio/socket/client/Manager;->opts:Lio/socket/client/Manager$Options;

    return-object p0
.end method

.method static synthetic access$300(Lio/socket/client/Manager;)Z
    .locals 0

    .line 22
    iget-boolean p0, p0, Lio/socket/client/Manager;->skipReconnect:Z

    return p0
.end method

.method static synthetic access$302(Lio/socket/client/Manager;Z)Z
    .locals 0

    .line 22
    iput-boolean p1, p0, Lio/socket/client/Manager;->skipReconnect:Z

    return p1
.end method

.method static synthetic access$400(Lio/socket/client/Manager;)V
    .locals 0

    .line 22
    invoke-direct {p0}, Lio/socket/client/Manager;->onopen()V

    return-void
.end method

.method static synthetic access$500(Lio/socket/client/Manager;)V
    .locals 0

    .line 22
    invoke-direct {p0}, Lio/socket/client/Manager;->cleanup()V

    return-void
.end method

.method static synthetic access$600(Lio/socket/client/Manager;)V
    .locals 0

    .line 22
    invoke-direct {p0}, Lio/socket/client/Manager;->maybeReconnectOnOpen()V

    return-void
.end method

.method static synthetic access$700(Lio/socket/client/Manager;)J
    .locals 2

    .line 22
    iget-wide v0, p0, Lio/socket/client/Manager;->_timeout:J

    return-wide v0
.end method

.method static synthetic access$800(Lio/socket/client/Manager;)Ljava/util/Queue;
    .locals 0

    .line 22
    iget-object p0, p0, Lio/socket/client/Manager;->subs:Ljava/util/Queue;

    return-object p0
.end method

.method static synthetic access$900(Lio/socket/client/Manager;)Lio/socket/parser/Parser$Decoder;
    .locals 0

    .line 22
    iget-object p0, p0, Lio/socket/client/Manager;->decoder:Lio/socket/parser/Parser$Decoder;

    return-object p0
.end method

.method private cleanup()V
    .locals 2

    .line 439
    sget-object v0, Lio/socket/client/Manager;->logger:Ljava/util/logging/Logger;

    const-string v1, "cleanup"

    invoke-virtual {v0, v1}, Ljava/util/logging/Logger;->fine(Ljava/lang/String;)V

    .line 442
    :goto_0
    iget-object v0, p0, Lio/socket/client/Manager;->subs:Ljava/util/Queue;

    invoke-interface {v0}, Ljava/util/Queue;->poll()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lio/socket/client/On$Handle;

    if-eqz v0, :cond_0

    invoke-interface {v0}, Lio/socket/client/On$Handle;->destroy()V

    goto :goto_0

    .line 443
    :cond_0
    iget-object v0, p0, Lio/socket/client/Manager;->decoder:Lio/socket/parser/Parser$Decoder;

    const/4 v1, 0x0

    invoke-interface {v0, v1}, Lio/socket/parser/Parser$Decoder;->onDecoded(Lio/socket/parser/Parser$Decoder$Callback;)V

    .line 445
    iget-object v0, p0, Lio/socket/client/Manager;->packetBuffer:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->clear()V

    const/4 v0, 0x0

    .line 446
    iput-boolean v0, p0, Lio/socket/client/Manager;->encoding:Z

    .line 448
    iget-object v0, p0, Lio/socket/client/Manager;->decoder:Lio/socket/parser/Parser$Decoder;

    invoke-interface {v0}, Lio/socket/parser/Parser$Decoder;->destroy()V

    return-void
.end method

.method private maybeReconnectOnOpen()V
    .locals 1

    .line 206
    iget-boolean v0, p0, Lio/socket/client/Manager;->reconnecting:Z

    if-nez v0, :cond_0

    iget-boolean v0, p0, Lio/socket/client/Manager;->_reconnection:Z

    if-eqz v0, :cond_0

    iget-object v0, p0, Lio/socket/client/Manager;->backoff:Lio/socket/backo/Backoff;

    invoke-virtual {v0}, Lio/socket/backo/Backoff;->getAttempts()I

    move-result v0

    if-nez v0, :cond_0

    .line 207
    invoke-direct {p0}, Lio/socket/client/Manager;->reconnect()V

    :cond_0
    return-void
.end method

.method private onclose(Ljava/lang/String;)V
    .locals 2

    .line 468
    sget-object v0, Lio/socket/client/Manager;->logger:Ljava/util/logging/Logger;

    const-string v1, "onclose"

    invoke-virtual {v0, v1}, Ljava/util/logging/Logger;->fine(Ljava/lang/String;)V

    .line 469
    invoke-direct {p0}, Lio/socket/client/Manager;->cleanup()V

    .line 470
    iget-object v0, p0, Lio/socket/client/Manager;->backoff:Lio/socket/backo/Backoff;

    invoke-virtual {v0}, Lio/socket/backo/Backoff;->reset()V

    .line 471
    sget-object v0, Lio/socket/client/Manager$ReadyState;->CLOSED:Lio/socket/client/Manager$ReadyState;

    iput-object v0, p0, Lio/socket/client/Manager;->readyState:Lio/socket/client/Manager$ReadyState;

    const/4 v0, 0x1

    new-array v0, v0, [Ljava/lang/Object;

    const/4 v1, 0x0

    aput-object p1, v0, v1

    const-string p1, "close"

    .line 472
    invoke-virtual {p0, p1, v0}, Lio/socket/client/Manager;->emit(Ljava/lang/String;[Ljava/lang/Object;)Lio/socket/emitter/Emitter;

    .line 474
    iget-boolean p1, p0, Lio/socket/client/Manager;->_reconnection:Z

    if-eqz p1, :cond_0

    iget-boolean p1, p0, Lio/socket/client/Manager;->skipReconnect:Z

    if-nez p1, :cond_0

    .line 475
    invoke-direct {p0}, Lio/socket/client/Manager;->reconnect()V

    :cond_0
    return-void
.end method

.method private ondecoded(Lio/socket/parser/Packet;)V
    .locals 2

    const/4 v0, 0x1

    new-array v0, v0, [Ljava/lang/Object;

    const/4 v1, 0x0

    aput-object p1, v0, v1

    const-string p1, "packet"

    .line 361
    invoke-virtual {p0, p1, v0}, Lio/socket/client/Manager;->emit(Ljava/lang/String;[Ljava/lang/Object;)Lio/socket/emitter/Emitter;

    return-void
.end method

.method private onerror(Ljava/lang/Exception;)V
    .locals 3

    .line 365
    sget-object v0, Lio/socket/client/Manager;->logger:Ljava/util/logging/Logger;

    sget-object v1, Ljava/util/logging/Level;->FINE:Ljava/util/logging/Level;

    const-string v2, "error"

    invoke-virtual {v0, v1, v2, p1}, Ljava/util/logging/Logger;->log(Ljava/util/logging/Level;Ljava/lang/String;Ljava/lang/Throwable;)V

    const/4 v0, 0x1

    new-array v0, v0, [Ljava/lang/Object;

    const/4 v1, 0x0

    aput-object p1, v0, v1

    .line 366
    invoke-virtual {p0, v2, v0}, Lio/socket/client/Manager;->emit(Ljava/lang/String;[Ljava/lang/Object;)Lio/socket/emitter/Emitter;

    return-void
.end method

.method private onopen()V
    .locals 4

    .line 317
    sget-object v0, Lio/socket/client/Manager;->logger:Ljava/util/logging/Logger;

    const-string v1, "open"

    invoke-virtual {v0, v1}, Ljava/util/logging/Logger;->fine(Ljava/lang/String;)V

    .line 319
    invoke-direct {p0}, Lio/socket/client/Manager;->cleanup()V

    .line 321
    sget-object v0, Lio/socket/client/Manager$ReadyState;->OPEN:Lio/socket/client/Manager$ReadyState;

    iput-object v0, p0, Lio/socket/client/Manager;->readyState:Lio/socket/client/Manager$ReadyState;

    const/4 v0, 0x0

    new-array v0, v0, [Ljava/lang/Object;

    .line 322
    invoke-virtual {p0, v1, v0}, Lio/socket/client/Manager;->emit(Ljava/lang/String;[Ljava/lang/Object;)Lio/socket/emitter/Emitter;

    .line 324
    iget-object v0, p0, Lio/socket/client/Manager;->engine:Lio/socket/engineio/client/Socket;

    .line 325
    iget-object v1, p0, Lio/socket/client/Manager;->subs:Ljava/util/Queue;

    new-instance v2, Lio/socket/client/Manager$2;

    invoke-direct {v2, p0}, Lio/socket/client/Manager$2;-><init>(Lio/socket/client/Manager;)V

    const-string v3, "data"

    invoke-static {v0, v3, v2}, Lio/socket/client/On;->on(Lio/socket/emitter/Emitter;Ljava/lang/String;Lio/socket/emitter/Emitter$Listener;)Lio/socket/client/On$Handle;

    move-result-object v2

    invoke-interface {v1, v2}, Ljava/util/Queue;->add(Ljava/lang/Object;)Z

    .line 340
    iget-object v1, p0, Lio/socket/client/Manager;->subs:Ljava/util/Queue;

    new-instance v2, Lio/socket/client/Manager$3;

    invoke-direct {v2, p0}, Lio/socket/client/Manager$3;-><init>(Lio/socket/client/Manager;)V

    const-string v3, "error"

    invoke-static {v0, v3, v2}, Lio/socket/client/On;->on(Lio/socket/emitter/Emitter;Ljava/lang/String;Lio/socket/emitter/Emitter$Listener;)Lio/socket/client/On$Handle;

    move-result-object v2

    invoke-interface {v1, v2}, Ljava/util/Queue;->add(Ljava/lang/Object;)Z

    .line 346
    iget-object v1, p0, Lio/socket/client/Manager;->subs:Ljava/util/Queue;

    new-instance v2, Lio/socket/client/Manager$4;

    invoke-direct {v2, p0}, Lio/socket/client/Manager$4;-><init>(Lio/socket/client/Manager;)V

    const-string v3, "close"

    invoke-static {v0, v3, v2}, Lio/socket/client/On;->on(Lio/socket/emitter/Emitter;Ljava/lang/String;Lio/socket/emitter/Emitter$Listener;)Lio/socket/client/On$Handle;

    move-result-object v0

    invoke-interface {v1, v0}, Ljava/util/Queue;->add(Ljava/lang/Object;)Z

    .line 352
    iget-object v0, p0, Lio/socket/client/Manager;->decoder:Lio/socket/parser/Parser$Decoder;

    new-instance v1, Lio/socket/client/Manager$5;

    invoke-direct {v1, p0}, Lio/socket/client/Manager$5;-><init>(Lio/socket/client/Manager;)V

    invoke-interface {v0, v1}, Lio/socket/parser/Parser$Decoder;->onDecoded(Lio/socket/parser/Parser$Decoder$Callback;)V

    return-void
.end method

.method private onreconnect()V
    .locals 3

    .line 539
    iget-object v0, p0, Lio/socket/client/Manager;->backoff:Lio/socket/backo/Backoff;

    invoke-virtual {v0}, Lio/socket/backo/Backoff;->getAttempts()I

    move-result v0

    const/4 v1, 0x0

    .line 540
    iput-boolean v1, p0, Lio/socket/client/Manager;->reconnecting:Z

    .line 541
    iget-object v2, p0, Lio/socket/client/Manager;->backoff:Lio/socket/backo/Backoff;

    invoke-virtual {v2}, Lio/socket/backo/Backoff;->reset()V

    const/4 v2, 0x1

    new-array v2, v2, [Ljava/lang/Object;

    .line 542
    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v0

    aput-object v0, v2, v1

    const-string v0, "reconnect"

    invoke-virtual {p0, v0, v2}, Lio/socket/client/Manager;->emit(Ljava/lang/String;[Ljava/lang/Object;)Lio/socket/emitter/Emitter;

    return-void
.end method

.method private processPacketQueue()V
    .locals 2

    .line 432
    iget-object v0, p0, Lio/socket/client/Manager;->packetBuffer:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_0

    iget-boolean v0, p0, Lio/socket/client/Manager;->encoding:Z

    if-nez v0, :cond_0

    .line 433
    iget-object v0, p0, Lio/socket/client/Manager;->packetBuffer:Ljava/util/List;

    const/4 v1, 0x0

    invoke-interface {v0, v1}, Ljava/util/List;->remove(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lio/socket/parser/Packet;

    .line 434
    invoke-virtual {p0, v0}, Lio/socket/client/Manager;->packet(Lio/socket/parser/Packet;)V

    :cond_0
    return-void
.end method

.method private reconnect()V
    .locals 7

    .line 480
    iget-boolean v0, p0, Lio/socket/client/Manager;->reconnecting:Z

    if-nez v0, :cond_2

    iget-boolean v0, p0, Lio/socket/client/Manager;->skipReconnect:Z

    if-eqz v0, :cond_0

    goto :goto_0

    .line 484
    :cond_0
    iget-object v0, p0, Lio/socket/client/Manager;->backoff:Lio/socket/backo/Backoff;

    invoke-virtual {v0}, Lio/socket/backo/Backoff;->getAttempts()I

    move-result v0

    iget v1, p0, Lio/socket/client/Manager;->_reconnectionAttempts:I

    const/4 v2, 0x0

    if-lt v0, v1, :cond_1

    .line 485
    sget-object v0, Lio/socket/client/Manager;->logger:Ljava/util/logging/Logger;

    const-string v1, "reconnect failed"

    invoke-virtual {v0, v1}, Ljava/util/logging/Logger;->fine(Ljava/lang/String;)V

    .line 486
    iget-object v0, p0, Lio/socket/client/Manager;->backoff:Lio/socket/backo/Backoff;

    invoke-virtual {v0}, Lio/socket/backo/Backoff;->reset()V

    new-array v0, v2, [Ljava/lang/Object;

    const-string v1, "reconnect_failed"

    .line 487
    invoke-virtual {p0, v1, v0}, Lio/socket/client/Manager;->emit(Ljava/lang/String;[Ljava/lang/Object;)Lio/socket/emitter/Emitter;

    .line 488
    iput-boolean v2, p0, Lio/socket/client/Manager;->reconnecting:Z

    goto :goto_0

    .line 490
    :cond_1
    iget-object v0, p0, Lio/socket/client/Manager;->backoff:Lio/socket/backo/Backoff;

    invoke-virtual {v0}, Lio/socket/backo/Backoff;->duration()J

    move-result-wide v0

    .line 491
    sget-object v3, Lio/socket/client/Manager;->logger:Ljava/util/logging/Logger;

    const/4 v4, 0x1

    new-array v5, v4, [Ljava/lang/Object;

    invoke-static {v0, v1}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v6

    aput-object v6, v5, v2

    const-string v2, "will wait %dms before reconnect attempt"

    invoke-static {v2, v5}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v3, v2}, Ljava/util/logging/Logger;->fine(Ljava/lang/String;)V

    .line 493
    iput-boolean v4, p0, Lio/socket/client/Manager;->reconnecting:Z

    .line 494
    new-instance v2, Ljava/util/Timer;

    invoke-direct {v2}, Ljava/util/Timer;-><init>()V

    .line 495
    new-instance v3, Lio/socket/client/Manager$7;

    invoke-direct {v3, p0, p0}, Lio/socket/client/Manager$7;-><init>(Lio/socket/client/Manager;Lio/socket/client/Manager;)V

    invoke-virtual {v2, v3, v0, v1}, Ljava/util/Timer;->schedule(Ljava/util/TimerTask;J)V

    .line 529
    iget-object v0, p0, Lio/socket/client/Manager;->subs:Ljava/util/Queue;

    new-instance v1, Lio/socket/client/Manager$8;

    invoke-direct {v1, p0, v2}, Lio/socket/client/Manager$8;-><init>(Lio/socket/client/Manager;Ljava/util/Timer;)V

    invoke-interface {v0, v1}, Ljava/util/Queue;->add(Ljava/lang/Object;)Z

    :cond_2
    :goto_0
    return-void
.end method


# virtual methods
.method close()V
    .locals 2

    .line 452
    sget-object v0, Lio/socket/client/Manager;->logger:Ljava/util/logging/Logger;

    const-string v1, "disconnect"

    invoke-virtual {v0, v1}, Ljava/util/logging/Logger;->fine(Ljava/lang/String;)V

    const/4 v0, 0x1

    .line 453
    iput-boolean v0, p0, Lio/socket/client/Manager;->skipReconnect:Z

    const/4 v0, 0x0

    .line 454
    iput-boolean v0, p0, Lio/socket/client/Manager;->reconnecting:Z

    .line 455
    iget-object v0, p0, Lio/socket/client/Manager;->readyState:Lio/socket/client/Manager$ReadyState;

    sget-object v1, Lio/socket/client/Manager$ReadyState;->OPEN:Lio/socket/client/Manager$ReadyState;

    if-eq v0, v1, :cond_0

    .line 458
    invoke-direct {p0}, Lio/socket/client/Manager;->cleanup()V

    .line 460
    :cond_0
    iget-object v0, p0, Lio/socket/client/Manager;->backoff:Lio/socket/backo/Backoff;

    invoke-virtual {v0}, Lio/socket/backo/Backoff;->reset()V

    .line 461
    sget-object v0, Lio/socket/client/Manager$ReadyState;->CLOSED:Lio/socket/client/Manager$ReadyState;

    iput-object v0, p0, Lio/socket/client/Manager;->readyState:Lio/socket/client/Manager$ReadyState;

    .line 462
    iget-object v0, p0, Lio/socket/client/Manager;->engine:Lio/socket/engineio/client/Socket;

    if-eqz v0, :cond_1

    .line 463
    invoke-virtual {v0}, Lio/socket/engineio/client/Socket;->close()Lio/socket/engineio/client/Socket;

    :cond_1
    return-void
.end method

.method destroy()V
    .locals 3

    .line 392
    iget-object v0, p0, Lio/socket/client/Manager;->nsps:Ljava/util/concurrent/ConcurrentHashMap;

    monitor-enter v0

    .line 393
    :try_start_0
    iget-object v1, p0, Lio/socket/client/Manager;->nsps:Ljava/util/concurrent/ConcurrentHashMap;

    invoke-virtual {v1}, Ljava/util/concurrent/ConcurrentHashMap;->values()Ljava/util/Collection;

    move-result-object v1

    invoke-interface {v1}, Ljava/util/Collection;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :cond_0
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_1

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lio/socket/client/Socket;

    .line 394
    invoke-virtual {v2}, Lio/socket/client/Socket;->isActive()Z

    move-result v2

    if-eqz v2, :cond_0

    .line 395
    sget-object v1, Lio/socket/client/Manager;->logger:Ljava/util/logging/Logger;

    const-string v2, "socket is still active, skipping close"

    invoke-virtual {v1, v2}, Ljava/util/logging/Logger;->fine(Ljava/lang/String;)V

    .line 396
    monitor-exit v0

    return-void

    .line 400
    :cond_1
    invoke-virtual {p0}, Lio/socket/client/Manager;->close()V

    .line 401
    monitor-exit v0

    return-void

    :catchall_0
    move-exception v1

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw v1
.end method

.method public isReconnecting()Z
    .locals 1

    .line 147
    iget-boolean v0, p0, Lio/socket/client/Manager;->reconnecting:Z

    return v0
.end method

.method public open()Lio/socket/client/Manager;
    .locals 1

    const/4 v0, 0x0

    .line 212
    invoke-virtual {p0, v0}, Lio/socket/client/Manager;->open(Lio/socket/client/Manager$OpenCallback;)Lio/socket/client/Manager;

    move-result-object v0

    return-object v0
.end method

.method public open(Lio/socket/client/Manager$OpenCallback;)Lio/socket/client/Manager;
    .locals 1

    .line 222
    new-instance v0, Lio/socket/client/Manager$1;

    invoke-direct {v0, p0, p1}, Lio/socket/client/Manager$1;-><init>(Lio/socket/client/Manager;Lio/socket/client/Manager$OpenCallback;)V

    invoke-static {v0}, Lio/socket/thread/EventThread;->exec(Ljava/lang/Runnable;)V

    return-object p0
.end method

.method packet(Lio/socket/parser/Packet;)V
    .locals 4

    .line 405
    sget-object v0, Lio/socket/client/Manager;->logger:Ljava/util/logging/Logger;

    sget-object v1, Ljava/util/logging/Level;->FINE:Ljava/util/logging/Level;

    invoke-virtual {v0, v1}, Ljava/util/logging/Logger;->isLoggable(Ljava/util/logging/Level;)Z

    move-result v1

    const/4 v2, 0x1

    if-eqz v1, :cond_0

    new-array v1, v2, [Ljava/lang/Object;

    const/4 v3, 0x0

    aput-object p1, v1, v3

    const-string v3, "writing packet %s"

    .line 406
    invoke-static {v3, v1}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/util/logging/Logger;->fine(Ljava/lang/String;)V

    .line 410
    :cond_0
    iget-boolean v0, p0, Lio/socket/client/Manager;->encoding:Z

    if-nez v0, :cond_1

    .line 411
    iput-boolean v2, p0, Lio/socket/client/Manager;->encoding:Z

    .line 412
    iget-object v0, p0, Lio/socket/client/Manager;->encoder:Lio/socket/parser/Parser$Encoder;

    new-instance v1, Lio/socket/client/Manager$6;

    invoke-direct {v1, p0, p0}, Lio/socket/client/Manager$6;-><init>(Lio/socket/client/Manager;Lio/socket/client/Manager;)V

    invoke-interface {v0, p1, v1}, Lio/socket/parser/Parser$Encoder;->encode(Lio/socket/parser/Packet;Lio/socket/parser/Parser$Encoder$Callback;)V

    goto :goto_0

    .line 427
    :cond_1
    iget-object v0, p0, Lio/socket/client/Manager;->packetBuffer:Ljava/util/List;

    invoke-interface {v0, p1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    :goto_0
    return-void
.end method

.method public final randomizationFactor()D
    .locals 2

    .line 172
    iget-wide v0, p0, Lio/socket/client/Manager;->_randomizationFactor:D

    return-wide v0
.end method

.method public randomizationFactor(D)Lio/socket/client/Manager;
    .locals 1

    .line 176
    iput-wide p1, p0, Lio/socket/client/Manager;->_randomizationFactor:D

    .line 177
    iget-object v0, p0, Lio/socket/client/Manager;->backoff:Lio/socket/backo/Backoff;

    if-eqz v0, :cond_0

    .line 178
    invoke-virtual {v0, p1, p2}, Lio/socket/backo/Backoff;->setJitter(D)Lio/socket/backo/Backoff;

    :cond_0
    return-object p0
.end method

.method public reconnection(Z)Lio/socket/client/Manager;
    .locals 0

    .line 142
    iput-boolean p1, p0, Lio/socket/client/Manager;->_reconnection:Z

    return-object p0
.end method

.method public reconnection()Z
    .locals 1

    .line 138
    iget-boolean v0, p0, Lio/socket/client/Manager;->_reconnection:Z

    return v0
.end method

.method public reconnectionAttempts()I
    .locals 1

    .line 151
    iget v0, p0, Lio/socket/client/Manager;->_reconnectionAttempts:I

    return v0
.end method

.method public reconnectionAttempts(I)Lio/socket/client/Manager;
    .locals 0

    .line 155
    iput p1, p0, Lio/socket/client/Manager;->_reconnectionAttempts:I

    return-object p0
.end method

.method public final reconnectionDelay()J
    .locals 2

    .line 160
    iget-wide v0, p0, Lio/socket/client/Manager;->_reconnectionDelay:J

    return-wide v0
.end method

.method public reconnectionDelay(J)Lio/socket/client/Manager;
    .locals 1

    .line 164
    iput-wide p1, p0, Lio/socket/client/Manager;->_reconnectionDelay:J

    .line 165
    iget-object v0, p0, Lio/socket/client/Manager;->backoff:Lio/socket/backo/Backoff;

    if-eqz v0, :cond_0

    .line 166
    invoke-virtual {v0, p1, p2}, Lio/socket/backo/Backoff;->setMin(J)Lio/socket/backo/Backoff;

    :cond_0
    return-object p0
.end method

.method public final reconnectionDelayMax()J
    .locals 2

    .line 184
    iget-wide v0, p0, Lio/socket/client/Manager;->_reconnectionDelayMax:J

    return-wide v0
.end method

.method public reconnectionDelayMax(J)Lio/socket/client/Manager;
    .locals 1

    .line 188
    iput-wide p1, p0, Lio/socket/client/Manager;->_reconnectionDelayMax:J

    .line 189
    iget-object v0, p0, Lio/socket/client/Manager;->backoff:Lio/socket/backo/Backoff;

    if-eqz v0, :cond_0

    .line 190
    invoke-virtual {v0, p1, p2}, Lio/socket/backo/Backoff;->setMax(J)Lio/socket/backo/Backoff;

    :cond_0
    return-object p0
.end method

.method public socket(Ljava/lang/String;)Lio/socket/client/Socket;
    .locals 1

    const/4 v0, 0x0

    .line 388
    invoke-virtual {p0, p1, v0}, Lio/socket/client/Manager;->socket(Ljava/lang/String;Lio/socket/client/Manager$Options;)Lio/socket/client/Socket;

    move-result-object p1

    return-object p1
.end method

.method public socket(Ljava/lang/String;Lio/socket/client/Manager$Options;)Lio/socket/client/Socket;
    .locals 2

    .line 377
    iget-object v0, p0, Lio/socket/client/Manager;->nsps:Ljava/util/concurrent/ConcurrentHashMap;

    monitor-enter v0

    .line 378
    :try_start_0
    iget-object v1, p0, Lio/socket/client/Manager;->nsps:Ljava/util/concurrent/ConcurrentHashMap;

    invoke-virtual {v1, p1}, Ljava/util/concurrent/ConcurrentHashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lio/socket/client/Socket;

    if-nez v1, :cond_0

    .line 380
    new-instance v1, Lio/socket/client/Socket;

    invoke-direct {v1, p0, p1, p2}, Lio/socket/client/Socket;-><init>(Lio/socket/client/Manager;Ljava/lang/String;Lio/socket/client/Manager$Options;)V

    .line 381
    iget-object p2, p0, Lio/socket/client/Manager;->nsps:Ljava/util/concurrent/ConcurrentHashMap;

    invoke-virtual {p2, p1, v1}, Ljava/util/concurrent/ConcurrentHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 383
    :cond_0
    monitor-exit v0

    return-object v1

    :catchall_0
    move-exception p1

    .line 384
    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw p1
.end method

.method public timeout()J
    .locals 2

    .line 196
    iget-wide v0, p0, Lio/socket/client/Manager;->_timeout:J

    return-wide v0
.end method

.method public timeout(J)Lio/socket/client/Manager;
    .locals 0

    .line 200
    iput-wide p1, p0, Lio/socket/client/Manager;->_timeout:J

    return-object p0
.end method
