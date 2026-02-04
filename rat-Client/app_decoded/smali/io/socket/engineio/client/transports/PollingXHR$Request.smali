.class public Lio/socket/engineio/client/transports/PollingXHR$Request;
.super Lio/socket/emitter/Emitter;
.source "PollingXHR.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lio/socket/engineio/client/transports/PollingXHR;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x9
    name = "Request"
.end annotation

.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lio/socket/engineio/client/transports/PollingXHR$Request$Options;
    }
.end annotation


# static fields
.field public static final EVENT_DATA:Ljava/lang/String; = "data"

.field public static final EVENT_ERROR:Ljava/lang/String; = "error"

.field public static final EVENT_REQUEST_HEADERS:Ljava/lang/String; = "requestHeaders"

.field public static final EVENT_RESPONSE_HEADERS:Ljava/lang/String; = "responseHeaders"

.field public static final EVENT_SUCCESS:Ljava/lang/String; = "success"

.field private static final TEXT_CONTENT_TYPE:Ljava/lang/String; = "text/plain;charset=UTF-8"

.field private static final TEXT_MEDIA_TYPE:Lokhttp3/MediaType;


# instance fields
.field private callFactory:Lokhttp3/Call$Factory;

.field private data:Ljava/lang/String;

.field private extraHeaders:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Ljava/util/List<",
            "Ljava/lang/String;",
            ">;>;"
        }
    .end annotation
.end field

.field private method:Ljava/lang/String;

.field private requestCall:Lokhttp3/Call;

.field private response:Lokhttp3/Response;

.field private uri:Ljava/lang/String;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    const-string v0, "text/plain;charset=UTF-8"

    .line 147
    invoke-static {v0}, Lokhttp3/MediaType;->parse(Ljava/lang/String;)Lokhttp3/MediaType;

    move-result-object v0

    sput-object v0, Lio/socket/engineio/client/transports/PollingXHR$Request;->TEXT_MEDIA_TYPE:Lokhttp3/MediaType;

    return-void
.end method

.method public constructor <init>(Lio/socket/engineio/client/transports/PollingXHR$Request$Options;)V
    .locals 1

    .line 159
    invoke-direct {p0}, Lio/socket/emitter/Emitter;-><init>()V

    .line 160
    iget-object v0, p1, Lio/socket/engineio/client/transports/PollingXHR$Request$Options;->method:Ljava/lang/String;

    if-eqz v0, :cond_0

    iget-object v0, p1, Lio/socket/engineio/client/transports/PollingXHR$Request$Options;->method:Ljava/lang/String;

    goto :goto_0

    :cond_0
    const-string v0, "GET"

    :goto_0
    iput-object v0, p0, Lio/socket/engineio/client/transports/PollingXHR$Request;->method:Ljava/lang/String;

    .line 161
    iget-object v0, p1, Lio/socket/engineio/client/transports/PollingXHR$Request$Options;->uri:Ljava/lang/String;

    iput-object v0, p0, Lio/socket/engineio/client/transports/PollingXHR$Request;->uri:Ljava/lang/String;

    .line 162
    iget-object v0, p1, Lio/socket/engineio/client/transports/PollingXHR$Request$Options;->data:Ljava/lang/String;

    iput-object v0, p0, Lio/socket/engineio/client/transports/PollingXHR$Request;->data:Ljava/lang/String;

    .line 163
    iget-object v0, p1, Lio/socket/engineio/client/transports/PollingXHR$Request$Options;->callFactory:Lokhttp3/Call$Factory;

    if-eqz v0, :cond_1

    iget-object v0, p1, Lio/socket/engineio/client/transports/PollingXHR$Request$Options;->callFactory:Lokhttp3/Call$Factory;

    goto :goto_1

    :cond_1
    new-instance v0, Lokhttp3/OkHttpClient;

    invoke-direct {v0}, Lokhttp3/OkHttpClient;-><init>()V

    :goto_1
    iput-object v0, p0, Lio/socket/engineio/client/transports/PollingXHR$Request;->callFactory:Lokhttp3/Call$Factory;

    .line 164
    iget-object p1, p1, Lio/socket/engineio/client/transports/PollingXHR$Request$Options;->extraHeaders:Ljava/util/Map;

    iput-object p1, p0, Lio/socket/engineio/client/transports/PollingXHR$Request;->extraHeaders:Ljava/util/Map;

    return-void
.end method

.method static synthetic access$400(Lio/socket/engineio/client/transports/PollingXHR$Request;Ljava/lang/Exception;)V
    .locals 0

    .line 137
    invoke-direct {p0, p1}, Lio/socket/engineio/client/transports/PollingXHR$Request;->onError(Ljava/lang/Exception;)V

    return-void
.end method

.method static synthetic access$502(Lio/socket/engineio/client/transports/PollingXHR$Request;Lokhttp3/Response;)Lokhttp3/Response;
    .locals 0

    .line 137
    iput-object p1, p0, Lio/socket/engineio/client/transports/PollingXHR$Request;->response:Lokhttp3/Response;

    return-object p1
.end method

.method static synthetic access$600(Lio/socket/engineio/client/transports/PollingXHR$Request;Ljava/util/Map;)V
    .locals 0

    .line 137
    invoke-direct {p0, p1}, Lio/socket/engineio/client/transports/PollingXHR$Request;->onResponseHeaders(Ljava/util/Map;)V

    return-void
.end method

.method static synthetic access$700(Lio/socket/engineio/client/transports/PollingXHR$Request;)V
    .locals 0

    .line 137
    invoke-direct {p0}, Lio/socket/engineio/client/transports/PollingXHR$Request;->onLoad()V

    return-void
.end method

.method private onData(Ljava/lang/String;)V
    .locals 2

    const/4 v0, 0x1

    new-array v0, v0, [Ljava/lang/Object;

    const/4 v1, 0x0

    aput-object p1, v0, v1

    const-string p1, "data"

    .line 232
    invoke-virtual {p0, p1, v0}, Lio/socket/engineio/client/transports/PollingXHR$Request;->emit(Ljava/lang/String;[Ljava/lang/Object;)Lio/socket/emitter/Emitter;

    .line 233
    invoke-direct {p0}, Lio/socket/engineio/client/transports/PollingXHR$Request;->onSuccess()V

    return-void
.end method

.method private onError(Ljava/lang/Exception;)V
    .locals 2

    const/4 v0, 0x1

    new-array v0, v0, [Ljava/lang/Object;

    const/4 v1, 0x0

    aput-object p1, v0, v1

    const-string p1, "error"

    .line 237
    invoke-virtual {p0, p1, v0}, Lio/socket/engineio/client/transports/PollingXHR$Request;->emit(Ljava/lang/String;[Ljava/lang/Object;)Lio/socket/emitter/Emitter;

    return-void
.end method

.method private onLoad()V
    .locals 1

    .line 249
    iget-object v0, p0, Lio/socket/engineio/client/transports/PollingXHR$Request;->response:Lokhttp3/Response;

    invoke-virtual {v0}, Lokhttp3/Response;->body()Lokhttp3/ResponseBody;

    move-result-object v0

    .line 252
    :try_start_0
    invoke-virtual {v0}, Lokhttp3/ResponseBody;->string()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Lio/socket/engineio/client/transports/PollingXHR$Request;->onData(Ljava/lang/String;)V
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception v0

    .line 254
    invoke-direct {p0, v0}, Lio/socket/engineio/client/transports/PollingXHR$Request;->onError(Ljava/lang/Exception;)V

    :goto_0
    return-void
.end method

.method private onRequestHeaders(Ljava/util/Map;)V
    .locals 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Ljava/util/List<",
            "Ljava/lang/String;",
            ">;>;)V"
        }
    .end annotation

    const/4 v0, 0x1

    new-array v0, v0, [Ljava/lang/Object;

    const/4 v1, 0x0

    aput-object p1, v0, v1

    const-string p1, "requestHeaders"

    .line 241
    invoke-virtual {p0, p1, v0}, Lio/socket/engineio/client/transports/PollingXHR$Request;->emit(Ljava/lang/String;[Ljava/lang/Object;)Lio/socket/emitter/Emitter;

    return-void
.end method

.method private onResponseHeaders(Ljava/util/Map;)V
    .locals 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Ljava/util/List<",
            "Ljava/lang/String;",
            ">;>;)V"
        }
    .end annotation

    const/4 v0, 0x1

    new-array v0, v0, [Ljava/lang/Object;

    const/4 v1, 0x0

    aput-object p1, v0, v1

    const-string p1, "responseHeaders"

    .line 245
    invoke-virtual {p0, p1, v0}, Lio/socket/engineio/client/transports/PollingXHR$Request;->emit(Ljava/lang/String;[Ljava/lang/Object;)Lio/socket/emitter/Emitter;

    return-void
.end method

.method private onSuccess()V
    .locals 2

    const/4 v0, 0x0

    new-array v0, v0, [Ljava/lang/Object;

    const-string v1, "success"

    .line 228
    invoke-virtual {p0, v1, v0}, Lio/socket/engineio/client/transports/PollingXHR$Request;->emit(Ljava/lang/String;[Ljava/lang/Object;)Lio/socket/emitter/Emitter;

    return-void
.end method


# virtual methods
.method public create()V
    .locals 6

    .line 169
    invoke-static {}, Lio/socket/engineio/client/transports/PollingXHR;->access$200()Z

    move-result v0

    const/4 v1, 0x1

    const/4 v2, 0x0

    const/4 v3, 0x2

    if-eqz v0, :cond_0

    invoke-static {}, Lio/socket/engineio/client/transports/PollingXHR;->access$300()Ljava/util/logging/Logger;

    move-result-object v0

    new-array v4, v3, [Ljava/lang/Object;

    iget-object v5, p0, Lio/socket/engineio/client/transports/PollingXHR$Request;->method:Ljava/lang/String;

    aput-object v5, v4, v2

    iget-object v5, p0, Lio/socket/engineio/client/transports/PollingXHR$Request;->uri:Ljava/lang/String;

    aput-object v5, v4, v1

    const-string v5, "xhr open %s: %s"

    invoke-static {v5, v4}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v0, v4}, Ljava/util/logging/Logger;->fine(Ljava/lang/String;)V

    .line 170
    :cond_0
    new-instance v0, Ljava/util/TreeMap;

    sget-object v4, Ljava/lang/String;->CASE_INSENSITIVE_ORDER:Ljava/util/Comparator;

    invoke-direct {v0, v4}, Ljava/util/TreeMap;-><init>(Ljava/util/Comparator;)V

    .line 171
    iget-object v4, p0, Lio/socket/engineio/client/transports/PollingXHR$Request;->extraHeaders:Ljava/util/Map;

    if-eqz v4, :cond_1

    .line 172
    invoke-interface {v0, v4}, Ljava/util/Map;->putAll(Ljava/util/Map;)V

    .line 174
    :cond_1
    iget-object v4, p0, Lio/socket/engineio/client/transports/PollingXHR$Request;->method:Ljava/lang/String;

    const-string v5, "POST"

    invoke-virtual {v5, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_2

    .line 175
    new-instance v4, Ljava/util/LinkedList;

    const-string v5, "text/plain;charset=UTF-8"

    invoke-static {v5}, Ljava/util/Collections;->singletonList(Ljava/lang/Object;)Ljava/util/List;

    move-result-object v5

    invoke-direct {v4, v5}, Ljava/util/LinkedList;-><init>(Ljava/util/Collection;)V

    const-string v5, "Content-type"

    invoke-interface {v0, v5, v4}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 178
    :cond_2
    new-instance v4, Ljava/util/LinkedList;

    const-string v5, "*/*"

    invoke-static {v5}, Ljava/util/Collections;->singletonList(Ljava/lang/Object;)Ljava/util/List;

    move-result-object v5

    invoke-direct {v4, v5}, Ljava/util/LinkedList;-><init>(Ljava/util/Collection;)V

    const-string v5, "Accept"

    invoke-interface {v0, v5, v4}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 180
    invoke-direct {p0, v0}, Lio/socket/engineio/client/transports/PollingXHR$Request;->onRequestHeaders(Ljava/util/Map;)V

    .line 182
    invoke-static {}, Lio/socket/engineio/client/transports/PollingXHR;->access$200()Z

    move-result v4

    if-eqz v4, :cond_3

    .line 183
    invoke-static {}, Lio/socket/engineio/client/transports/PollingXHR;->access$300()Ljava/util/logging/Logger;

    move-result-object v4

    new-array v3, v3, [Ljava/lang/Object;

    iget-object v5, p0, Lio/socket/engineio/client/transports/PollingXHR$Request;->uri:Ljava/lang/String;

    aput-object v5, v3, v2

    iget-object v2, p0, Lio/socket/engineio/client/transports/PollingXHR$Request;->data:Ljava/lang/String;

    aput-object v2, v3, v1

    const-string v1, "sending xhr with url %s | data %s"

    invoke-static {v1, v3}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v4, v1}, Ljava/util/logging/Logger;->fine(Ljava/lang/String;)V

    .line 186
    :cond_3
    new-instance v1, Lokhttp3/Request$Builder;

    invoke-direct {v1}, Lokhttp3/Request$Builder;-><init>()V

    .line 187
    invoke-interface {v0}, Ljava/util/Map;->entrySet()Ljava/util/Set;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :cond_4
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_5

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/util/Map$Entry;

    .line 188
    invoke-interface {v2}, Ljava/util/Map$Entry;->getValue()Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Ljava/util/List;

    invoke-interface {v3}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v3

    :goto_0
    invoke-interface {v3}, Ljava/util/Iterator;->hasNext()Z

    move-result v4

    if-eqz v4, :cond_4

    invoke-interface {v3}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Ljava/lang/String;

    .line 189
    invoke-interface {v2}, Ljava/util/Map$Entry;->getKey()Ljava/lang/Object;

    move-result-object v5

    check-cast v5, Ljava/lang/String;

    invoke-virtual {v1, v5, v4}, Lokhttp3/Request$Builder;->addHeader(Ljava/lang/String;Ljava/lang/String;)Lokhttp3/Request$Builder;

    goto :goto_0

    :cond_5
    const/4 v0, 0x0

    .line 193
    iget-object v2, p0, Lio/socket/engineio/client/transports/PollingXHR$Request;->data:Ljava/lang/String;

    if-eqz v2, :cond_6

    .line 194
    sget-object v0, Lio/socket/engineio/client/transports/PollingXHR$Request;->TEXT_MEDIA_TYPE:Lokhttp3/MediaType;

    invoke-static {v0, v2}, Lokhttp3/RequestBody;->create(Lokhttp3/MediaType;Ljava/lang/String;)Lokhttp3/RequestBody;

    move-result-object v0

    .line 197
    :cond_6
    iget-object v2, p0, Lio/socket/engineio/client/transports/PollingXHR$Request;->uri:Ljava/lang/String;

    .line 198
    invoke-static {v2}, Lokhttp3/HttpUrl;->parse(Ljava/lang/String;)Lokhttp3/HttpUrl;

    move-result-object v2

    invoke-virtual {v1, v2}, Lokhttp3/Request$Builder;->url(Lokhttp3/HttpUrl;)Lokhttp3/Request$Builder;

    move-result-object v1

    iget-object v2, p0, Lio/socket/engineio/client/transports/PollingXHR$Request;->method:Ljava/lang/String;

    .line 199
    invoke-virtual {v1, v2, v0}, Lokhttp3/Request$Builder;->method(Ljava/lang/String;Lokhttp3/RequestBody;)Lokhttp3/Request$Builder;

    move-result-object v0

    .line 200
    invoke-virtual {v0}, Lokhttp3/Request$Builder;->build()Lokhttp3/Request;

    move-result-object v0

    .line 202
    iget-object v1, p0, Lio/socket/engineio/client/transports/PollingXHR$Request;->callFactory:Lokhttp3/Call$Factory;

    invoke-interface {v1, v0}, Lokhttp3/Call$Factory;->newCall(Lokhttp3/Request;)Lokhttp3/Call;

    move-result-object v0

    iput-object v0, p0, Lio/socket/engineio/client/transports/PollingXHR$Request;->requestCall:Lokhttp3/Call;

    .line 203
    new-instance v1, Lio/socket/engineio/client/transports/PollingXHR$Request$1;

    invoke-direct {v1, p0, p0}, Lio/socket/engineio/client/transports/PollingXHR$Request$1;-><init>(Lio/socket/engineio/client/transports/PollingXHR$Request;Lio/socket/engineio/client/transports/PollingXHR$Request;)V

    invoke-interface {v0, v1}, Lokhttp3/Call;->enqueue(Lokhttp3/Callback;)V

    return-void
.end method
