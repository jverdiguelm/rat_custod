.class Lio/socket/client/Manager$2;
.super Ljava/lang/Object;
.source "Manager.java"

# interfaces
.implements Lio/socket/emitter/Emitter$Listener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lio/socket/client/Manager;->onopen()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lio/socket/client/Manager;


# direct methods
.method constructor <init>(Lio/socket/client/Manager;)V
    .locals 0

    .line 325
    iput-object p1, p0, Lio/socket/client/Manager$2;->this$0:Lio/socket/client/Manager;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public varargs call([Ljava/lang/Object;)V
    .locals 3

    const/4 v0, 0x0

    .line 328
    aget-object p1, p1, v0

    .line 330
    :try_start_0
    instance-of v0, p1, Ljava/lang/String;

    if-eqz v0, :cond_0

    .line 331
    iget-object v0, p0, Lio/socket/client/Manager$2;->this$0:Lio/socket/client/Manager;

    invoke-static {v0}, Lio/socket/client/Manager;->access$900(Lio/socket/client/Manager;)Lio/socket/parser/Parser$Decoder;

    move-result-object v0

    check-cast p1, Ljava/lang/String;

    invoke-interface {v0, p1}, Lio/socket/parser/Parser$Decoder;->add(Ljava/lang/String;)V

    goto :goto_0

    .line 332
    :cond_0
    instance-of v0, p1, [B

    if-eqz v0, :cond_1

    .line 333
    iget-object v0, p0, Lio/socket/client/Manager$2;->this$0:Lio/socket/client/Manager;

    invoke-static {v0}, Lio/socket/client/Manager;->access$900(Lio/socket/client/Manager;)Lio/socket/parser/Parser$Decoder;

    move-result-object v0

    check-cast p1, [B

    check-cast p1, [B

    invoke-interface {v0, p1}, Lio/socket/parser/Parser$Decoder;->add([B)V
    :try_end_0
    .catch Lio/socket/parser/DecodingException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception p1

    .line 336
    invoke-static {}, Lio/socket/client/Manager;->access$000()Ljava/util/logging/Logger;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "error while decoding the packet: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Lio/socket/parser/DecodingException;->getMessage()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v0, p1}, Ljava/util/logging/Logger;->fine(Ljava/lang/String;)V

    :cond_1
    :goto_0
    return-void
.end method
