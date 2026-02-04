.class final Lio/socket/engineio/parser/Parser$2;
.super Ljava/lang/Object;
.source "Parser.java"

# interfaces
.implements Lio/socket/engineio/parser/Parser$EncodeCallback;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lio/socket/engineio/parser/Parser;->encodePayload([Lio/socket/engineio/parser/Packet;Lio/socket/engineio/parser/Parser$EncodeCallback;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x8
    name = null
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Object;",
        "Lio/socket/engineio/parser/Parser$EncodeCallback<",
        "Ljava/lang/String;",
        ">;"
    }
.end annotation


# instance fields
.field final synthetic val$isLast:Z

.field final synthetic val$result:Ljava/lang/StringBuilder;


# direct methods
.method constructor <init>(Ljava/lang/StringBuilder;Z)V
    .locals 0

    .line 102
    iput-object p1, p0, Lio/socket/engineio/parser/Parser$2;->val$result:Ljava/lang/StringBuilder;

    iput-boolean p2, p0, Lio/socket/engineio/parser/Parser$2;->val$isLast:Z

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public bridge synthetic call(Ljava/lang/Object;)V
    .locals 0

    .line 102
    check-cast p1, Ljava/lang/String;

    invoke-virtual {p0, p1}, Lio/socket/engineio/parser/Parser$2;->call(Ljava/lang/String;)V

    return-void
.end method

.method public call(Ljava/lang/String;)V
    .locals 1

    .line 105
    iget-object v0, p0, Lio/socket/engineio/parser/Parser$2;->val$result:Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 106
    iget-boolean p1, p0, Lio/socket/engineio/parser/Parser$2;->val$isLast:Z

    if-nez p1, :cond_0

    .line 107
    iget-object p1, p0, Lio/socket/engineio/parser/Parser$2;->val$result:Ljava/lang/StringBuilder;

    const/16 v0, 0x1e

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    :cond_0
    return-void
.end method
