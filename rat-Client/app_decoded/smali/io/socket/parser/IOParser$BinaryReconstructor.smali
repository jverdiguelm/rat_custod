.class Lio/socket/parser/IOParser$BinaryReconstructor;
.super Ljava/lang/Object;
.source "IOParser.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lio/socket/parser/IOParser;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x8
    name = "BinaryReconstructor"
.end annotation


# instance fields
.field buffers:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "[B>;"
        }
    .end annotation
.end field

.field public reconPack:Lio/socket/parser/Packet;


# direct methods
.method constructor <init>(Lio/socket/parser/Packet;)V
    .locals 0

    .line 240
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 241
    iput-object p1, p0, Lio/socket/parser/IOParser$BinaryReconstructor;->reconPack:Lio/socket/parser/Packet;

    .line 242
    new-instance p1, Ljava/util/ArrayList;

    invoke-direct {p1}, Ljava/util/ArrayList;-><init>()V

    iput-object p1, p0, Lio/socket/parser/IOParser$BinaryReconstructor;->buffers:Ljava/util/List;

    return-void
.end method


# virtual methods
.method public finishReconstruction()V
    .locals 1

    const/4 v0, 0x0

    .line 257
    iput-object v0, p0, Lio/socket/parser/IOParser$BinaryReconstructor;->reconPack:Lio/socket/parser/Packet;

    .line 258
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    iput-object v0, p0, Lio/socket/parser/IOParser$BinaryReconstructor;->buffers:Ljava/util/List;

    return-void
.end method

.method public takeBinaryData([B)Lio/socket/parser/Packet;
    .locals 2

    .line 246
    iget-object v0, p0, Lio/socket/parser/IOParser$BinaryReconstructor;->buffers:Ljava/util/List;

    invoke-interface {v0, p1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 247
    iget-object p1, p0, Lio/socket/parser/IOParser$BinaryReconstructor;->buffers:Ljava/util/List;

    invoke-interface {p1}, Ljava/util/List;->size()I

    move-result p1

    iget-object v0, p0, Lio/socket/parser/IOParser$BinaryReconstructor;->reconPack:Lio/socket/parser/Packet;

    iget v0, v0, Lio/socket/parser/Packet;->attachments:I

    if-ne p1, v0, :cond_0

    .line 248
    iget-object p1, p0, Lio/socket/parser/IOParser$BinaryReconstructor;->reconPack:Lio/socket/parser/Packet;

    iget-object v0, p0, Lio/socket/parser/IOParser$BinaryReconstructor;->buffers:Ljava/util/List;

    .line 249
    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v1

    new-array v1, v1, [[B

    invoke-interface {v0, v1}, Ljava/util/List;->toArray([Ljava/lang/Object;)[Ljava/lang/Object;

    move-result-object v0

    check-cast v0, [[B

    .line 248
    invoke-static {p1, v0}, Lio/socket/parser/Binary;->reconstructPacket(Lio/socket/parser/Packet;[[B)Lio/socket/parser/Packet;

    move-result-object p1

    .line 250
    invoke-virtual {p0}, Lio/socket/parser/IOParser$BinaryReconstructor;->finishReconstruction()V

    return-object p1

    :cond_0
    const/4 p1, 0x0

    return-object p1
.end method
