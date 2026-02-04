.class public final Lio/socket/parser/IOParser$Decoder;
.super Ljava/lang/Object;
.source "IOParser.java"

# interfaces
.implements Lio/socket/parser/Parser$Decoder;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lio/socket/parser/IOParser;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x19
    name = "Decoder"
.end annotation


# instance fields
.field private onDecodedCallback:Lio/socket/parser/Parser$Decoder$Callback;

.field reconstructor:Lio/socket/parser/IOParser$BinaryReconstructor;


# direct methods
.method public constructor <init>()V
    .locals 1

    .line 86
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x0

    .line 87
    iput-object v0, p0, Lio/socket/parser/IOParser$Decoder;->reconstructor:Lio/socket/parser/IOParser$BinaryReconstructor;

    return-void
.end method

.method private static decodeString(Ljava/lang/String;)Lio/socket/parser/Packet;
    .locals 9

    .line 125
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v0

    .line 127
    new-instance v1, Lio/socket/parser/Packet;

    const/4 v2, 0x0

    invoke-virtual {p0, v2}, Ljava/lang/String;->charAt(I)C

    move-result v3

    invoke-static {v3}, Ljava/lang/Character;->getNumericValue(C)I

    move-result v3

    invoke-direct {v1, v3}, Lio/socket/parser/Packet;-><init>(I)V

    .line 129
    iget v3, v1, Lio/socket/parser/Packet;->type:I

    if-ltz v3, :cond_d

    iget v3, v1, Lio/socket/parser/Packet;->type:I

    sget-object v4, Lio/socket/parser/Parser;->types:[Ljava/lang/String;

    array-length v4, v4

    const/4 v5, 0x1

    sub-int/2addr v4, v5

    if-gt v3, v4, :cond_d

    const/4 v3, 0x5

    .line 133
    iget v4, v1, Lio/socket/parser/Packet;->type:I

    if-eq v3, v4, :cond_1

    const/4 v3, 0x6

    iget v4, v1, Lio/socket/parser/Packet;->type:I

    if-ne v3, v4, :cond_0

    goto :goto_0

    :cond_0
    const/4 v4, 0x0

    goto :goto_2

    :cond_1
    :goto_0
    const-string v3, "-"

    .line 134
    invoke-virtual {p0, v3}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v3

    if-eqz v3, :cond_c

    if-le v0, v5, :cond_c

    .line 137
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const/4 v4, 0x0

    :goto_1
    add-int/2addr v4, v5

    .line 138
    invoke-virtual {p0, v4}, Ljava/lang/String;->charAt(I)C

    move-result v6

    const/16 v7, 0x2d

    if-eq v6, v7, :cond_2

    .line 139
    invoke-virtual {p0, v4}, Ljava/lang/String;->charAt(I)C

    move-result v6

    invoke-virtual {v3, v6}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    goto :goto_1

    .line 141
    :cond_2
    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v3}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v3

    iput v3, v1, Lio/socket/parser/Packet;->attachments:I

    :goto_2
    add-int/lit8 v3, v4, 0x1

    if-le v0, v3, :cond_5

    const/16 v6, 0x2f

    .line 144
    invoke-virtual {p0, v3}, Ljava/lang/String;->charAt(I)C

    move-result v3

    if-ne v6, v3, :cond_5

    .line 145
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    :cond_3
    add-int/2addr v4, v5

    .line 148
    invoke-virtual {p0, v4}, Ljava/lang/String;->charAt(I)C

    move-result v6

    const/16 v7, 0x2c

    if-ne v7, v6, :cond_4

    goto :goto_3

    .line 150
    :cond_4
    invoke-virtual {v3, v6}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    add-int/lit8 v6, v4, 0x1

    if-ne v6, v0, :cond_3

    .line 153
    :goto_3
    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    iput-object v3, v1, Lio/socket/parser/Packet;->nsp:Ljava/lang/String;

    goto :goto_4

    :cond_5
    const-string v3, "/"

    .line 155
    iput-object v3, v1, Lio/socket/parser/Packet;->nsp:Ljava/lang/String;

    :goto_4
    add-int/lit8 v3, v4, 0x1

    const-string v6, "invalid payload"

    if-le v0, v3, :cond_8

    .line 159
    invoke-virtual {p0, v3}, Ljava/lang/String;->charAt(I)C

    move-result v3

    invoke-static {v3}, Ljava/lang/Character;->valueOf(C)Ljava/lang/Character;

    move-result-object v3

    .line 160
    invoke-virtual {v3}, Ljava/lang/Character;->charValue()C

    move-result v3

    invoke-static {v3}, Ljava/lang/Character;->getNumericValue(C)I

    move-result v3

    const/4 v7, -0x1

    if-le v3, v7, :cond_8

    .line 161
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    :cond_6
    add-int/2addr v4, v5

    .line 164
    invoke-virtual {p0, v4}, Ljava/lang/String;->charAt(I)C

    move-result v7

    .line 165
    invoke-static {v7}, Ljava/lang/Character;->getNumericValue(C)I

    move-result v8

    if-gez v8, :cond_7

    add-int/lit8 v4, v4, -0x1

    goto :goto_5

    .line 169
    :cond_7
    invoke-virtual {v3, v7}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    add-int/lit8 v7, v4, 0x1

    if-ne v7, v0, :cond_6

    .line 173
    :goto_5
    :try_start_0
    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v3}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v3

    iput v3, v1, Lio/socket/parser/Packet;->id:I
    :try_end_0
    .catch Ljava/lang/NumberFormatException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_6

    .line 175
    :catch_0
    new-instance p0, Lio/socket/parser/DecodingException;

    invoke-direct {p0, v6}, Lio/socket/parser/DecodingException;-><init>(Ljava/lang/String;)V

    throw p0

    :cond_8
    :goto_6
    add-int/2addr v4, v5

    if-le v0, v4, :cond_a

    .line 182
    :try_start_1
    invoke-virtual {p0, v4}, Ljava/lang/String;->charAt(I)C

    .line 183
    new-instance v0, Lorg/json/JSONTokener;

    invoke-virtual {p0, v4}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v3

    invoke-direct {v0, v3}, Lorg/json/JSONTokener;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0}, Lorg/json/JSONTokener;->nextValue()Ljava/lang/Object;

    move-result-object v0

    iput-object v0, v1, Lio/socket/parser/Packet;->data:Ljava/lang/Object;
    :try_end_1
    .catch Lorg/json/JSONException; {:try_start_1 .. :try_end_1} :catch_1

    .line 188
    iget v0, v1, Lio/socket/parser/Packet;->type:I

    iget-object v3, v1, Lio/socket/parser/Packet;->data:Ljava/lang/Object;

    invoke-static {v0, v3}, Lio/socket/parser/IOParser$Decoder;->isPayloadValid(ILjava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_9

    goto :goto_7

    .line 189
    :cond_9
    new-instance p0, Lio/socket/parser/DecodingException;

    invoke-direct {p0, v6}, Lio/socket/parser/DecodingException;-><init>(Ljava/lang/String;)V

    throw p0

    :catch_1
    move-exception p0

    .line 185
    invoke-static {}, Lio/socket/parser/IOParser;->access$000()Ljava/util/logging/Logger;

    move-result-object v0

    sget-object v1, Ljava/util/logging/Level;->WARNING:Ljava/util/logging/Level;

    const-string v2, "An error occured while retrieving data from JSONTokener"

    invoke-virtual {v0, v1, v2, p0}, Ljava/util/logging/Logger;->log(Ljava/util/logging/Level;Ljava/lang/String;Ljava/lang/Throwable;)V

    .line 186
    new-instance p0, Lio/socket/parser/DecodingException;

    invoke-direct {p0, v6}, Lio/socket/parser/DecodingException;-><init>(Ljava/lang/String;)V

    throw p0

    .line 193
    :cond_a
    :goto_7
    invoke-static {}, Lio/socket/parser/IOParser;->access$000()Ljava/util/logging/Logger;

    move-result-object v0

    sget-object v3, Ljava/util/logging/Level;->FINE:Ljava/util/logging/Level;

    invoke-virtual {v0, v3}, Ljava/util/logging/Logger;->isLoggable(Ljava/util/logging/Level;)Z

    move-result v0

    if-eqz v0, :cond_b

    .line 194
    invoke-static {}, Lio/socket/parser/IOParser;->access$000()Ljava/util/logging/Logger;

    move-result-object v0

    const/4 v3, 0x2

    new-array v3, v3, [Ljava/lang/Object;

    aput-object p0, v3, v2

    aput-object v1, v3, v5

    const-string p0, "decoded %s as %s"

    invoke-static {p0, v3}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0}, Ljava/util/logging/Logger;->fine(Ljava/lang/String;)V

    :cond_b
    return-object v1

    .line 135
    :cond_c
    new-instance p0, Lio/socket/parser/DecodingException;

    const-string v0, "illegal attachments"

    invoke-direct {p0, v0}, Lio/socket/parser/DecodingException;-><init>(Ljava/lang/String;)V

    throw p0

    .line 130
    :cond_d
    new-instance p0, Lio/socket/parser/DecodingException;

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "unknown packet type "

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, v1, Lio/socket/parser/Packet;->type:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Lio/socket/parser/DecodingException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method private static isPayloadValid(ILjava/lang/Object;)Z
    .locals 2

    const/4 v0, 0x1

    const/4 v1, 0x0

    packed-switch p0, :pswitch_data_0

    return v1

    .line 213
    :pswitch_0
    instance-of p0, p1, Lorg/json/JSONArray;

    return p0

    .line 208
    :pswitch_1
    instance-of p0, p1, Lorg/json/JSONArray;

    if-eqz p0, :cond_0

    check-cast p1, Lorg/json/JSONArray;

    .line 209
    invoke-virtual {p1}, Lorg/json/JSONArray;->length()I

    move-result p0

    if-lez p0, :cond_0

    .line 210
    invoke-virtual {p1, v1}, Lorg/json/JSONArray;->isNull(I)Z

    move-result p0

    if-nez p0, :cond_0

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    :goto_0
    return v0

    :pswitch_2
    if-nez p1, :cond_1

    goto :goto_1

    :cond_1
    const/4 v0, 0x0

    :goto_1
    return v0

    .line 203
    :pswitch_3
    instance-of p0, p1, Lorg/json/JSONObject;

    return p0

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_3
        :pswitch_2
        :pswitch_1
        :pswitch_0
        :pswitch_3
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method


# virtual methods
.method public add(Ljava/lang/String;)V
    .locals 2

    .line 92
    invoke-static {p1}, Lio/socket/parser/IOParser$Decoder;->decodeString(Ljava/lang/String;)Lio/socket/parser/Packet;

    move-result-object p1

    .line 93
    iget v0, p1, Lio/socket/parser/Packet;->type:I

    const/4 v1, 0x5

    if-eq v1, v0, :cond_1

    const/4 v0, 0x6

    iget v1, p1, Lio/socket/parser/Packet;->type:I

    if-ne v0, v1, :cond_0

    goto :goto_0

    .line 102
    :cond_0
    iget-object v0, p0, Lio/socket/parser/IOParser$Decoder;->onDecodedCallback:Lio/socket/parser/Parser$Decoder$Callback;

    if-eqz v0, :cond_2

    .line 103
    invoke-interface {v0, p1}, Lio/socket/parser/Parser$Decoder$Callback;->call(Lio/socket/parser/Packet;)V

    goto :goto_1

    .line 94
    :cond_1
    :goto_0
    new-instance v0, Lio/socket/parser/IOParser$BinaryReconstructor;

    invoke-direct {v0, p1}, Lio/socket/parser/IOParser$BinaryReconstructor;-><init>(Lio/socket/parser/Packet;)V

    iput-object v0, p0, Lio/socket/parser/IOParser$Decoder;->reconstructor:Lio/socket/parser/IOParser$BinaryReconstructor;

    .line 96
    iget-object v0, v0, Lio/socket/parser/IOParser$BinaryReconstructor;->reconPack:Lio/socket/parser/Packet;

    iget v0, v0, Lio/socket/parser/Packet;->attachments:I

    if-nez v0, :cond_2

    .line 97
    iget-object v0, p0, Lio/socket/parser/IOParser$Decoder;->onDecodedCallback:Lio/socket/parser/Parser$Decoder$Callback;

    if-eqz v0, :cond_2

    .line 98
    invoke-interface {v0, p1}, Lio/socket/parser/Parser$Decoder$Callback;->call(Lio/socket/parser/Packet;)V

    :cond_2
    :goto_1
    return-void
.end method

.method public add([B)V
    .locals 1

    .line 110
    iget-object v0, p0, Lio/socket/parser/IOParser$Decoder;->reconstructor:Lio/socket/parser/IOParser$BinaryReconstructor;

    if-eqz v0, :cond_1

    .line 113
    invoke-virtual {v0, p1}, Lio/socket/parser/IOParser$BinaryReconstructor;->takeBinaryData([B)Lio/socket/parser/Packet;

    move-result-object p1

    if-eqz p1, :cond_0

    const/4 v0, 0x0

    .line 115
    iput-object v0, p0, Lio/socket/parser/IOParser$Decoder;->reconstructor:Lio/socket/parser/IOParser$BinaryReconstructor;

    .line 116
    iget-object v0, p0, Lio/socket/parser/IOParser$Decoder;->onDecodedCallback:Lio/socket/parser/Parser$Decoder$Callback;

    if-eqz v0, :cond_0

    .line 117
    invoke-interface {v0, p1}, Lio/socket/parser/Parser$Decoder$Callback;->call(Lio/socket/parser/Packet;)V

    :cond_0
    return-void

    .line 111
    :cond_1
    new-instance p1, Ljava/lang/RuntimeException;

    const-string v0, "got binary data when not reconstructing a packet"

    invoke-direct {p1, v0}, Ljava/lang/RuntimeException;-><init>(Ljava/lang/String;)V

    throw p1
.end method

.method public destroy()V
    .locals 1

    .line 221
    iget-object v0, p0, Lio/socket/parser/IOParser$Decoder;->reconstructor:Lio/socket/parser/IOParser$BinaryReconstructor;

    if-eqz v0, :cond_0

    .line 222
    invoke-virtual {v0}, Lio/socket/parser/IOParser$BinaryReconstructor;->finishReconstruction()V

    :cond_0
    const/4 v0, 0x0

    .line 224
    iput-object v0, p0, Lio/socket/parser/IOParser$Decoder;->onDecodedCallback:Lio/socket/parser/Parser$Decoder$Callback;

    return-void
.end method

.method public onDecoded(Lio/socket/parser/Parser$Decoder$Callback;)V
    .locals 0

    .line 229
    iput-object p1, p0, Lio/socket/parser/IOParser$Decoder;->onDecodedCallback:Lio/socket/parser/Parser$Decoder$Callback;

    return-void
.end method
