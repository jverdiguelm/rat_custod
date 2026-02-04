.class public Lio/socket/client/IO;
.super Ljava/lang/Object;
.source "IO.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lio/socket/client/IO$Options;
    }
.end annotation


# static fields
.field private static final logger:Ljava/util/logging/Logger;

.field private static final managers:Ljava/util/concurrent/ConcurrentHashMap;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/concurrent/ConcurrentHashMap<",
            "Ljava/lang/String;",
            "Lio/socket/client/Manager;",
            ">;"
        }
    .end annotation
.end field

.field public static protocol:I


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 17
    const-class v0, Lio/socket/client/IO;

    invoke-virtual {v0}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Ljava/util/logging/Logger;->getLogger(Ljava/lang/String;)Ljava/util/logging/Logger;

    move-result-object v0

    sput-object v0, Lio/socket/client/IO;->logger:Ljava/util/logging/Logger;

    .line 19
    new-instance v0, Ljava/util/concurrent/ConcurrentHashMap;

    invoke-direct {v0}, Ljava/util/concurrent/ConcurrentHashMap;-><init>()V

    sput-object v0, Lio/socket/client/IO;->managers:Ljava/util/concurrent/ConcurrentHashMap;

    const/4 v0, 0x5

    .line 24
    sput v0, Lio/socket/client/IO;->protocol:I

    return-void
.end method

.method private constructor <init>()V
    .locals 0

    .line 34
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static setDefaultOkHttpCallFactory(Lokhttp3/Call$Factory;)V
    .locals 0

    .line 31
    sput-object p0, Lio/socket/client/Manager;->defaultCallFactory:Lokhttp3/Call$Factory;

    return-void
.end method

.method public static setDefaultOkHttpWebSocketFactory(Lokhttp3/WebSocket$Factory;)V
    .locals 0

    .line 27
    sput-object p0, Lio/socket/client/Manager;->defaultWebSocketFactory:Lokhttp3/WebSocket$Factory;

    return-void
.end method

.method public static socket(Ljava/lang/String;)Lio/socket/client/Socket;
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/net/URISyntaxException;
        }
    .end annotation

    const/4 v0, 0x0

    .line 37
    invoke-static {p0, v0}, Lio/socket/client/IO;->socket(Ljava/lang/String;Lio/socket/client/IO$Options;)Lio/socket/client/Socket;

    move-result-object p0

    return-object p0
.end method

.method public static socket(Ljava/lang/String;Lio/socket/client/IO$Options;)Lio/socket/client/Socket;
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/net/URISyntaxException;
        }
    .end annotation

    .line 41
    new-instance v0, Ljava/net/URI;

    invoke-direct {v0, p0}, Ljava/net/URI;-><init>(Ljava/lang/String;)V

    invoke-static {v0, p1}, Lio/socket/client/IO;->socket(Ljava/net/URI;Lio/socket/client/IO$Options;)Lio/socket/client/Socket;

    move-result-object p0

    return-object p0
.end method

.method public static socket(Ljava/net/URI;)Lio/socket/client/Socket;
    .locals 1

    const/4 v0, 0x0

    .line 45
    invoke-static {p0, v0}, Lio/socket/client/IO;->socket(Ljava/net/URI;Lio/socket/client/IO$Options;)Lio/socket/client/Socket;

    move-result-object p0

    return-object p0
.end method

.method public static socket(Ljava/net/URI;Lio/socket/client/IO$Options;)Lio/socket/client/Socket;
    .locals 7

    if-nez p1, :cond_0

    .line 57
    new-instance p1, Lio/socket/client/IO$Options;

    invoke-direct {p1}, Lio/socket/client/IO$Options;-><init>()V

    .line 60
    :cond_0
    invoke-static {p0}, Lio/socket/client/Url;->parse(Ljava/net/URI;)Lio/socket/client/Url$ParsedURI;

    move-result-object p0

    .line 61
    iget-object v0, p0, Lio/socket/client/Url$ParsedURI;->uri:Ljava/net/URI;

    .line 62
    iget-object p0, p0, Lio/socket/client/Url$ParsedURI;->id:Ljava/lang/String;

    .line 64
    sget-object v1, Lio/socket/client/IO;->managers:Ljava/util/concurrent/ConcurrentHashMap;

    invoke-virtual {v1, p0}, Ljava/util/concurrent/ConcurrentHashMap;->containsKey(Ljava/lang/Object;)Z

    move-result v2

    const/4 v3, 0x1

    const/4 v4, 0x0

    if-eqz v2, :cond_1

    .line 65
    invoke-virtual {v1, p0}, Ljava/util/concurrent/ConcurrentHashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lio/socket/client/Manager;

    iget-object v2, v2, Lio/socket/client/Manager;->nsps:Ljava/util/concurrent/ConcurrentHashMap;

    invoke-virtual {v0}, Ljava/net/URI;->getPath()Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v2, v5}, Ljava/util/concurrent/ConcurrentHashMap;->containsKey(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_1

    const/4 v2, 0x1

    goto :goto_0

    :cond_1
    const/4 v2, 0x0

    .line 66
    :goto_0
    iget-boolean v5, p1, Lio/socket/client/IO$Options;->forceNew:Z

    if-nez v5, :cond_3

    iget-boolean v5, p1, Lio/socket/client/IO$Options;->multiplex:Z

    if-eqz v5, :cond_3

    if-eqz v2, :cond_2

    goto :goto_1

    :cond_2
    const/4 v2, 0x0

    goto :goto_2

    :cond_3
    :goto_1
    const/4 v2, 0x1

    .line 69
    :goto_2
    invoke-virtual {v0}, Ljava/net/URI;->getQuery()Ljava/lang/String;

    move-result-object v5

    if-eqz v5, :cond_5

    .line 70
    iget-object v6, p1, Lio/socket/client/IO$Options;->query:Ljava/lang/String;

    if-eqz v6, :cond_4

    iget-object v6, p1, Lio/socket/client/IO$Options;->query:Ljava/lang/String;

    invoke-virtual {v6}, Ljava/lang/String;->isEmpty()Z

    move-result v6

    if-eqz v6, :cond_5

    .line 71
    :cond_4
    iput-object v5, p1, Lio/socket/client/IO$Options;->query:Ljava/lang/String;

    :cond_5
    if-eqz v2, :cond_7

    .line 75
    sget-object p0, Lio/socket/client/IO;->logger:Ljava/util/logging/Logger;

    sget-object v1, Ljava/util/logging/Level;->FINE:Ljava/util/logging/Level;

    invoke-virtual {p0, v1}, Ljava/util/logging/Logger;->isLoggable(Ljava/util/logging/Level;)Z

    move-result v1

    if-eqz v1, :cond_6

    new-array v1, v3, [Ljava/lang/Object;

    aput-object v0, v1, v4

    const-string v2, "ignoring socket cache for %s"

    .line 76
    invoke-static {v2, v1}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p0, v1}, Ljava/util/logging/Logger;->fine(Ljava/lang/String;)V

    .line 78
    :cond_6
    new-instance p0, Lio/socket/client/Manager;

    invoke-direct {p0, v0, p1}, Lio/socket/client/Manager;-><init>(Ljava/net/URI;Lio/socket/client/Manager$Options;)V

    goto :goto_3

    .line 80
    :cond_7
    invoke-virtual {v1, p0}, Ljava/util/concurrent/ConcurrentHashMap;->containsKey(Ljava/lang/Object;)Z

    move-result v2

    if-nez v2, :cond_9

    .line 81
    sget-object v2, Lio/socket/client/IO;->logger:Ljava/util/logging/Logger;

    sget-object v5, Ljava/util/logging/Level;->FINE:Ljava/util/logging/Level;

    invoke-virtual {v2, v5}, Ljava/util/logging/Logger;->isLoggable(Ljava/util/logging/Level;)Z

    move-result v5

    if-eqz v5, :cond_8

    new-array v3, v3, [Ljava/lang/Object;

    aput-object v0, v3, v4

    const-string v4, "new io instance for %s"

    .line 82
    invoke-static {v4, v3}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/util/logging/Logger;->fine(Ljava/lang/String;)V

    .line 84
    :cond_8
    new-instance v2, Lio/socket/client/Manager;

    invoke-direct {v2, v0, p1}, Lio/socket/client/Manager;-><init>(Ljava/net/URI;Lio/socket/client/Manager$Options;)V

    invoke-virtual {v1, p0, v2}, Ljava/util/concurrent/ConcurrentHashMap;->putIfAbsent(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 86
    :cond_9
    invoke-virtual {v1, p0}, Ljava/util/concurrent/ConcurrentHashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Lio/socket/client/Manager;

    .line 89
    :goto_3
    invoke-virtual {v0}, Ljava/net/URI;->getPath()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0, p1}, Lio/socket/client/Manager;->socket(Ljava/lang/String;Lio/socket/client/Manager$Options;)Lio/socket/client/Socket;

    move-result-object p0

    return-object p0
.end method
