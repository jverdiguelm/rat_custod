.class Lio/socket/client/Manager$7$1;
.super Ljava/lang/Object;
.source "Manager.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lio/socket/client/Manager$7;->run()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$1:Lio/socket/client/Manager$7;


# direct methods
.method constructor <init>(Lio/socket/client/Manager$7;)V
    .locals 0

    .line 498
    iput-object p1, p0, Lio/socket/client/Manager$7$1;->this$1:Lio/socket/client/Manager$7;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 4

    .line 501
    iget-object v0, p0, Lio/socket/client/Manager$7$1;->this$1:Lio/socket/client/Manager$7;

    iget-object v0, v0, Lio/socket/client/Manager$7;->val$self:Lio/socket/client/Manager;

    invoke-static {v0}, Lio/socket/client/Manager;->access$300(Lio/socket/client/Manager;)Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 503
    :cond_0
    invoke-static {}, Lio/socket/client/Manager;->access$000()Ljava/util/logging/Logger;

    move-result-object v0

    const-string v1, "attempting reconnect"

    invoke-virtual {v0, v1}, Ljava/util/logging/Logger;->fine(Ljava/lang/String;)V

    .line 504
    iget-object v0, p0, Lio/socket/client/Manager$7$1;->this$1:Lio/socket/client/Manager$7;

    iget-object v0, v0, Lio/socket/client/Manager$7;->val$self:Lio/socket/client/Manager;

    invoke-static {v0}, Lio/socket/client/Manager;->access$1500(Lio/socket/client/Manager;)Lio/socket/backo/Backoff;

    move-result-object v0

    invoke-virtual {v0}, Lio/socket/backo/Backoff;->getAttempts()I

    move-result v0

    .line 505
    iget-object v1, p0, Lio/socket/client/Manager$7$1;->this$1:Lio/socket/client/Manager$7;

    iget-object v1, v1, Lio/socket/client/Manager$7;->val$self:Lio/socket/client/Manager;

    const/4 v2, 0x1

    new-array v2, v2, [Ljava/lang/Object;

    const/4 v3, 0x0

    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v0

    aput-object v0, v2, v3

    const-string v0, "reconnect_attempt"

    invoke-virtual {v1, v0, v2}, Lio/socket/client/Manager;->emit(Ljava/lang/String;[Ljava/lang/Object;)Lio/socket/emitter/Emitter;

    .line 508
    iget-object v0, p0, Lio/socket/client/Manager$7$1;->this$1:Lio/socket/client/Manager$7;

    iget-object v0, v0, Lio/socket/client/Manager$7;->val$self:Lio/socket/client/Manager;

    invoke-static {v0}, Lio/socket/client/Manager;->access$300(Lio/socket/client/Manager;)Z

    move-result v0

    if-eqz v0, :cond_1

    return-void

    .line 510
    :cond_1
    iget-object v0, p0, Lio/socket/client/Manager$7$1;->this$1:Lio/socket/client/Manager$7;

    iget-object v0, v0, Lio/socket/client/Manager$7;->val$self:Lio/socket/client/Manager;

    new-instance v1, Lio/socket/client/Manager$7$1$1;

    invoke-direct {v1, p0}, Lio/socket/client/Manager$7$1$1;-><init>(Lio/socket/client/Manager$7$1;)V

    invoke-virtual {v0, v1}, Lio/socket/client/Manager;->open(Lio/socket/client/Manager$OpenCallback;)Lio/socket/client/Manager;

    return-void
.end method
