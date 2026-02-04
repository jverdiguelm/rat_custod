.class public Lio/socket/engineio/parser/Parser;
.super Ljava/lang/Object;
.source "Parser.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lio/socket/engineio/parser/Parser$DecodePayloadCallback;,
        Lio/socket/engineio/parser/Parser$EncodeCallback;
    }
.end annotation


# static fields
.field public static final PROTOCOL:I = 0x4

.field private static final SEPARATOR:C = '\u001e'

.field private static final err:Lio/socket/engineio/parser/Packet;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Lio/socket/engineio/parser/Packet<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field

.field private static final packets:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Ljava/lang/Integer;",
            ">;"
        }
    .end annotation
.end field

.field private static final packetslist:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map<",
            "Ljava/lang/Integer;",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method static constructor <clinit>()V
    .locals 4

    .line 12
    new-instance v0, Lio/socket/engineio/parser/Parser$1;

    invoke-direct {v0}, Lio/socket/engineio/parser/Parser$1;-><init>()V

    sput-object v0, Lio/socket/engineio/parser/Parser;->packets:Ljava/util/Map;

    .line 22
    new-instance v1, Ljava/util/HashMap;

    invoke-direct {v1}, Ljava/util/HashMap;-><init>()V

    sput-object v1, Lio/socket/engineio/parser/Parser;->packetslist:Ljava/util/Map;

    .line 24
    invoke-interface {v0}, Ljava/util/Map;->entrySet()Ljava/util/Set;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_0

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/util/Map$Entry;

    .line 25
    sget-object v2, Lio/socket/engineio/parser/Parser;->packetslist:Ljava/util/Map;

    invoke-interface {v1}, Ljava/util/Map$Entry;->getValue()Ljava/lang/Object;

    move-result-object v3

    invoke-interface {v1}, Ljava/util/Map$Entry;->getKey()Ljava/lang/Object;

    move-result-object v1

    invoke-interface {v2, v3, v1}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    goto :goto_0

    .line 29
    :cond_0
    new-instance v0, Lio/socket/engineio/parser/Packet;

    const-string v1, "error"

    const-string v2, "parser error"

    invoke-direct {v0, v1, v2}, Lio/socket/engineio/parser/Packet;-><init>(Ljava/lang/String;Ljava/lang/Object;)V

    sput-object v0, Lio/socket/engineio/parser/Parser;->err:Lio/socket/engineio/parser/Packet;

    return-void
.end method

.method private constructor <init>()V
    .locals 0

    .line 31
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static decodeBase64Packet(Ljava/lang/String;)Lio/socket/engineio/parser/Packet;
    .locals 3

    if-nez p0, :cond_0

    .line 78
    sget-object p0, Lio/socket/engineio/parser/Parser;->err:Lio/socket/engineio/parser/Packet;

    return-object p0

    :cond_0
    const/4 v0, 0x0

    .line 81
    invoke-virtual {p0, v0}, Ljava/lang/String;->charAt(I)C

    move-result v1

    const/16 v2, 0x62

    if-ne v1, v2, :cond_1

    .line 82
    new-instance v1, Lio/socket/engineio/parser/Packet;

    const/4 v2, 0x1

    invoke-virtual {p0, v2}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object p0

    invoke-static {p0, v0}, Lio/socket/engineio/parser/Base64;->decode(Ljava/lang/String;I)[B

    move-result-object p0

    const-string v0, "message"

    invoke-direct {v1, v0, p0}, Lio/socket/engineio/parser/Packet;-><init>(Ljava/lang/String;Ljava/lang/Object;)V

    return-object v1

    .line 84
    :cond_1
    invoke-static {p0}, Lio/socket/engineio/parser/Parser;->decodePacket(Ljava/lang/String;)Lio/socket/engineio/parser/Packet;

    move-result-object p0

    return-object p0
.end method

.method public static decodePacket(Ljava/lang/String;)Lio/socket/engineio/parser/Packet;
    .locals 4
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/String;",
            ")",
            "Lio/socket/engineio/parser/Packet<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation

    if-nez p0, :cond_0

    .line 55
    sget-object p0, Lio/socket/engineio/parser/Parser;->err:Lio/socket/engineio/parser/Packet;

    return-object p0

    :cond_0
    const/4 v0, 0x0

    .line 60
    :try_start_0
    invoke-virtual {p0, v0}, Ljava/lang/String;->charAt(I)C

    move-result v0

    invoke-static {v0}, Ljava/lang/Character;->getNumericValue(C)I

    move-result v0
    :try_end_0
    .catch Ljava/lang/IndexOutOfBoundsException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    const/4 v0, -0x1

    :goto_0
    if-ltz v0, :cond_3

    .line 65
    sget-object v1, Lio/socket/engineio/parser/Parser;->packetslist:Ljava/util/Map;

    invoke-interface {v1}, Ljava/util/Map;->size()I

    move-result v2

    if-lt v0, v2, :cond_1

    goto :goto_1

    .line 69
    :cond_1
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v2

    const/4 v3, 0x1

    if-le v2, v3, :cond_2

    .line 70
    new-instance v2, Lio/socket/engineio/parser/Packet;

    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v0

    invoke-interface {v1, v0}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    invoke-virtual {p0, v3}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object p0

    invoke-direct {v2, v0, p0}, Lio/socket/engineio/parser/Packet;-><init>(Ljava/lang/String;Ljava/lang/Object;)V

    return-object v2

    .line 72
    :cond_2
    new-instance p0, Lio/socket/engineio/parser/Packet;

    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v0

    invoke-interface {v1, v0}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    invoke-direct {p0, v0}, Lio/socket/engineio/parser/Packet;-><init>(Ljava/lang/String;)V

    return-object p0

    .line 66
    :cond_3
    :goto_1
    sget-object p0, Lio/socket/engineio/parser/Parser;->err:Lio/socket/engineio/parser/Packet;

    return-object p0
.end method

.method public static decodePacket([B)Lio/socket/engineio/parser/Packet;
    .locals 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "([B)",
            "Lio/socket/engineio/parser/Packet<",
            "[B>;"
        }
    .end annotation

    .line 89
    new-instance v0, Lio/socket/engineio/parser/Packet;

    const-string v1, "message"

    invoke-direct {v0, v1, p0}, Lio/socket/engineio/parser/Packet;-><init>(Ljava/lang/String;Ljava/lang/Object;)V

    return-object v0
.end method

.method public static decodePayload(Ljava/lang/String;Lio/socket/engineio/parser/Parser$DecodePayloadCallback;)V
    .locals 8
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/String;",
            "Lio/socket/engineio/parser/Parser$DecodePayloadCallback<",
            "Ljava/lang/String;",
            ">;)V"
        }
    .end annotation

    const/4 v0, 0x1

    const/4 v1, 0x0

    if-eqz p0, :cond_4

    .line 117
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v2

    if-nez v2, :cond_0

    goto :goto_1

    :cond_0
    const/16 v2, 0x1e

    .line 122
    invoke-static {v2}, Ljava/lang/String;->valueOf(C)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {p0, v2}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object p0

    .line 124
    array-length v2, p0

    const/4 v3, 0x0

    :goto_0
    if-ge v3, v2, :cond_3

    .line 125
    aget-object v4, p0, v3

    invoke-static {v4}, Lio/socket/engineio/parser/Parser;->decodeBase64Packet(Ljava/lang/String;)Lio/socket/engineio/parser/Packet;

    move-result-object v4

    .line 126
    sget-object v5, Lio/socket/engineio/parser/Parser;->err:Lio/socket/engineio/parser/Packet;

    iget-object v6, v5, Lio/socket/engineio/parser/Packet;->type:Ljava/lang/String;

    iget-object v7, v4, Lio/socket/engineio/parser/Packet;->type:Ljava/lang/String;

    invoke-virtual {v6, v7}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v6

    if-eqz v6, :cond_1

    iget-object v6, v5, Lio/socket/engineio/parser/Packet;->data:Ljava/lang/Object;

    check-cast v6, Ljava/lang/String;

    iget-object v7, v4, Lio/socket/engineio/parser/Packet;->data:Ljava/lang/Object;

    invoke-virtual {v6, v7}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v6

    if-eqz v6, :cond_1

    .line 127
    invoke-interface {p1, v5, v1, v0}, Lio/socket/engineio/parser/Parser$DecodePayloadCallback;->call(Lio/socket/engineio/parser/Packet;II)Z

    return-void

    .line 131
    :cond_1
    invoke-interface {p1, v4, v3, v2}, Lio/socket/engineio/parser/Parser$DecodePayloadCallback;->call(Lio/socket/engineio/parser/Packet;II)Z

    move-result v4

    if-nez v4, :cond_2

    return-void

    :cond_2
    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    :cond_3
    return-void

    .line 118
    :cond_4
    :goto_1
    sget-object p0, Lio/socket/engineio/parser/Parser;->err:Lio/socket/engineio/parser/Packet;

    invoke-interface {p1, p0, v1, v0}, Lio/socket/engineio/parser/Parser$DecodePayloadCallback;->call(Lio/socket/engineio/parser/Packet;II)Z

    return-void
.end method

.method public static encodePacket(Lio/socket/engineio/parser/Packet;Lio/socket/engineio/parser/Parser$EncodeCallback;)V
    .locals 2

    .line 34
    iget-object v0, p0, Lio/socket/engineio/parser/Packet;->data:Ljava/lang/Object;

    instance-of v0, v0, [B

    if-eqz v0, :cond_0

    .line 35
    iget-object p0, p0, Lio/socket/engineio/parser/Packet;->data:Ljava/lang/Object;

    invoke-interface {p1, p0}, Lio/socket/engineio/parser/Parser$EncodeCallback;->call(Ljava/lang/Object;)V

    goto :goto_1

    .line 37
    :cond_0
    sget-object v0, Lio/socket/engineio/parser/Parser;->packets:Ljava/util/Map;

    iget-object v1, p0, Lio/socket/engineio/parser/Packet;->type:Ljava/lang/String;

    invoke-interface {v0, v1}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    invoke-static {v0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    .line 38
    iget-object v1, p0, Lio/socket/engineio/parser/Packet;->data:Ljava/lang/Object;

    if-eqz v1, :cond_1

    iget-object p0, p0, Lio/socket/engineio/parser/Packet;->data:Ljava/lang/Object;

    invoke-static {p0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p0

    goto :goto_0

    :cond_1
    const-string p0, ""

    .line 39
    :goto_0
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-interface {p1, p0}, Lio/socket/engineio/parser/Parser$EncodeCallback;->call(Ljava/lang/Object;)V

    :goto_1
    return-void
.end method

.method private static encodePacketAsBase64(Lio/socket/engineio/parser/Packet;Lio/socket/engineio/parser/Parser$EncodeCallback;)V
    .locals 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Lio/socket/engineio/parser/Packet;",
            "Lio/socket/engineio/parser/Parser$EncodeCallback<",
            "Ljava/lang/String;",
            ">;)V"
        }
    .end annotation

    .line 44
    iget-object v0, p0, Lio/socket/engineio/parser/Packet;->data:Ljava/lang/Object;

    instance-of v0, v0, [B

    if-eqz v0, :cond_0

    .line 45
    iget-object p0, p0, Lio/socket/engineio/parser/Packet;->data:Ljava/lang/Object;

    check-cast p0, [B

    .line 46
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "b"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const/4 v1, 0x0

    invoke-static {p0, v1}, Lio/socket/engineio/parser/Base64;->encodeToString([BI)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    .line 47
    invoke-interface {p1, p0}, Lio/socket/engineio/parser/Parser$EncodeCallback;->call(Ljava/lang/Object;)V

    goto :goto_0

    .line 49
    :cond_0
    invoke-static {p0, p1}, Lio/socket/engineio/parser/Parser;->encodePacket(Lio/socket/engineio/parser/Packet;Lio/socket/engineio/parser/Parser$EncodeCallback;)V

    :goto_0
    return-void
.end method

.method public static encodePayload([Lio/socket/engineio/parser/Packet;Lio/socket/engineio/parser/Parser$EncodeCallback;)V
    .locals 7
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "([",
            "Lio/socket/engineio/parser/Packet;",
            "Lio/socket/engineio/parser/Parser$EncodeCallback<",
            "Ljava/lang/String;",
            ">;)V"
        }
    .end annotation

    .line 93
    array-length v0, p0

    if-nez v0, :cond_0

    const-string p0, "0:"

    .line 94
    invoke-interface {p1, p0}, Lio/socket/engineio/parser/Parser$EncodeCallback;->call(Ljava/lang/Object;)V

    return-void

    .line 98
    :cond_0
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    .line 100
    array-length v1, p0

    const/4 v2, 0x0

    const/4 v3, 0x0

    :goto_0
    if-ge v3, v1, :cond_2

    add-int/lit8 v4, v1, -0x1

    if-ne v3, v4, :cond_1

    const/4 v4, 0x1

    goto :goto_1

    :cond_1
    const/4 v4, 0x0

    .line 102
    :goto_1
    aget-object v5, p0, v3

    new-instance v6, Lio/socket/engineio/parser/Parser$2;

    invoke-direct {v6, v0, v4}, Lio/socket/engineio/parser/Parser$2;-><init>(Ljava/lang/StringBuilder;Z)V

    invoke-static {v5, v6}, Lio/socket/engineio/parser/Parser;->encodePacketAsBase64(Lio/socket/engineio/parser/Packet;Lio/socket/engineio/parser/Parser$EncodeCallback;)V

    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    .line 113
    :cond_2
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-interface {p1, p0}, Lio/socket/engineio/parser/Parser$EncodeCallback;->call(Ljava/lang/Object;)V

    return-void
.end method
