.class Lahmyth/mine/king/ahmyth/LocManager$1;
.super Ljava/lang/Object;
.source "LocManager.java"

# interfaces
.implements Landroid/location/LocationListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lahmyth/mine/king/ahmyth/LocManager;->lambda$getLocationAsync$1(Lahmyth/mine/king/ahmyth/LocManager$LocationResultCallback;ZZ)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lahmyth/mine/king/ahmyth/LocManager;

.field final synthetic val$callback:Lahmyth/mine/king/ahmyth/LocManager$LocationResultCallback;

.field final synthetic val$handler:Landroid/os/Handler;

.field final synthetic val$responded:[Z


# direct methods
.method constructor <init>(Lahmyth/mine/king/ahmyth/LocManager;[ZLandroid/os/Handler;Lahmyth/mine/king/ahmyth/LocManager$LocationResultCallback;)V
    .locals 0

    .line 58
    iput-object p1, p0, Lahmyth/mine/king/ahmyth/LocManager$1;->this$0:Lahmyth/mine/king/ahmyth/LocManager;

    iput-object p2, p0, Lahmyth/mine/king/ahmyth/LocManager$1;->val$responded:[Z

    iput-object p3, p0, Lahmyth/mine/king/ahmyth/LocManager$1;->val$handler:Landroid/os/Handler;

    iput-object p4, p0, Lahmyth/mine/king/ahmyth/LocManager$1;->val$callback:Lahmyth/mine/king/ahmyth/LocManager$LocationResultCallback;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onLocationChanged(Landroid/location/Location;)V
    .locals 3

    .line 61
    iget-object v0, p0, Lahmyth/mine/king/ahmyth/LocManager$1;->val$responded:[Z

    const/4 v1, 0x0

    aget-boolean v2, v0, v1

    if-nez v2, :cond_0

    const/4 v2, 0x1

    .line 62
    aput-boolean v2, v0, v1

    .line 63
    iget-object v0, p0, Lahmyth/mine/king/ahmyth/LocManager$1;->val$handler:Landroid/os/Handler;

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Landroid/os/Handler;->removeCallbacksAndMessages(Ljava/lang/Object;)V

    .line 64
    iget-object v0, p0, Lahmyth/mine/king/ahmyth/LocManager$1;->this$0:Lahmyth/mine/king/ahmyth/LocManager;

    invoke-static {v0}, Lahmyth/mine/king/ahmyth/LocManager;->access$000(Lahmyth/mine/king/ahmyth/LocManager;)Landroid/location/LocationManager;

    move-result-object v0

    invoke-virtual {v0, p0}, Landroid/location/LocationManager;->removeUpdates(Landroid/location/LocationListener;)V

    .line 65
    iget-object v0, p0, Lahmyth/mine/king/ahmyth/LocManager$1;->val$callback:Lahmyth/mine/king/ahmyth/LocManager$LocationResultCallback;

    invoke-interface {v0, p1, v1}, Lahmyth/mine/king/ahmyth/LocManager$LocationResultCallback;->onResult(Landroid/location/Location;Ljava/lang/String;)V

    :cond_0
    return-void
.end method

.method public onProviderDisabled(Ljava/lang/String;)V
    .locals 0

    return-void
.end method

.method public onProviderEnabled(Ljava/lang/String;)V
    .locals 0

    return-void
.end method

.method public onStatusChanged(Ljava/lang/String;ILandroid/os/Bundle;)V
    .locals 0

    return-void
.end method
