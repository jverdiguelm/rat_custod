.class Lio/socket/engineio/client/Socket$1;
.super Ljava/lang/Object;
.source "Socket.java"

# interfaces
.implements Lio/socket/emitter/Emitter$Listener;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lio/socket/engineio/client/Socket;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lio/socket/engineio/client/Socket;


# direct methods
.method constructor <init>(Lio/socket/engineio/client/Socket;)V
    .locals 0

    .line 137
    iput-object p1, p0, Lio/socket/engineio/client/Socket$1;->this$0:Lio/socket/engineio/client/Socket;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public varargs call([Ljava/lang/Object;)V
    .locals 0

    .line 140
    iget-object p1, p0, Lio/socket/engineio/client/Socket$1;->this$0:Lio/socket/engineio/client/Socket;

    invoke-static {p1}, Lio/socket/engineio/client/Socket;->access$000(Lio/socket/engineio/client/Socket;)V

    return-void
.end method
