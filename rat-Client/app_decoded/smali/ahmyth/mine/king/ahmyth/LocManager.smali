.class public Lahmyth/mine/king/ahmyth/LocManager;
.super Ljava/lang/Object;
.source "LocManager.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lahmyth/mine/king/ahmyth/LocManager$LocationResultCallback;
    }
.end annotation


# instance fields
.field private locationManager:Landroid/location/LocationManager;

.field private final mContext:Landroid/content/Context;


# direct methods
.method public constructor <init>(Landroid/content/Context;)V
    .locals 0

    .line 23
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 24
    iput-object p1, p0, Lahmyth/mine/king/ahmyth/LocManager;->mContext:Landroid/content/Context;

    return-void
.end method

.method static synthetic access$000(Lahmyth/mine/king/ahmyth/LocManager;)Landroid/location/LocationManager;
    .locals 0

    .line 18
    iget-object p0, p0, Lahmyth/mine/king/ahmyth/LocManager;->locationManager:Landroid/location/LocationManager;

    return-object p0
.end method

.method private hasLocationPermission()Z
    .locals 5

    .line 97
    iget-object v0, p0, Lahmyth/mine/king/ahmyth/LocManager;->mContext:Landroid/content/Context;

    const/4 v1, 0x0

    if-nez v0, :cond_0

    return v1

    .line 98
    :cond_0
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v2, 0x17

    const/4 v3, 0x1

    if-lt v0, v2, :cond_5

    .line 99
    iget-object v0, p0, Lahmyth/mine/king/ahmyth/LocManager;->mContext:Landroid/content/Context;

    const-string v2, "android.permission.ACCESS_FINE_LOCATION"

    invoke-static {v0, v2}, Landroidx/core/app/ActivityCompat;->checkSelfPermission(Landroid/content/Context;Ljava/lang/String;)I

    move-result v0

    if-nez v0, :cond_1

    const/4 v0, 0x1

    goto :goto_0

    :cond_1
    const/4 v0, 0x0

    .line 100
    :goto_0
    iget-object v2, p0, Lahmyth/mine/king/ahmyth/LocManager;->mContext:Landroid/content/Context;

    const-string v4, "android.permission.ACCESS_COARSE_LOCATION"

    invoke-static {v2, v4}, Landroidx/core/app/ActivityCompat;->checkSelfPermission(Landroid/content/Context;Ljava/lang/String;)I

    move-result v2

    if-nez v2, :cond_2

    const/4 v2, 0x1

    goto :goto_1

    :cond_2
    const/4 v2, 0x0

    :goto_1
    if-nez v0, :cond_3

    if-eqz v2, :cond_4

    :cond_3
    const/4 v1, 0x1

    :cond_4
    return v1

    :cond_5
    return v3
.end method


# virtual methods
.method public getLocationAsync(Lahmyth/mine/king/ahmyth/LocManager$LocationResultCallback;)V
    .locals 4

    .line 34
    iget-object v0, p0, Lahmyth/mine/king/ahmyth/LocManager;->mContext:Landroid/content/Context;

    const/4 v1, 0x0

    if-nez v0, :cond_0

    const-string v0, "Context is null"

    .line 35
    invoke-interface {p1, v1, v0}, Lahmyth/mine/king/ahmyth/LocManager$LocationResultCallback;->onResult(Landroid/location/Location;Ljava/lang/String;)V

    return-void

    .line 38
    :cond_0
    invoke-direct {p0}, Lahmyth/mine/king/ahmyth/LocManager;->hasLocationPermission()Z

    move-result v0

    if-nez v0, :cond_1

    const-string v0, "No location permission"

    .line 39
    invoke-interface {p1, v1, v0}, Lahmyth/mine/king/ahmyth/LocManager$LocationResultCallback;->onResult(Landroid/location/Location;Ljava/lang/String;)V

    return-void

    .line 42
    :cond_1
    iget-object v0, p0, Lahmyth/mine/king/ahmyth/LocManager;->mContext:Landroid/content/Context;

    const-string v2, "location"

    invoke-virtual {v0, v2}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/location/LocationManager;

    iput-object v0, p0, Lahmyth/mine/king/ahmyth/LocManager;->locationManager:Landroid/location/LocationManager;

    const-string v2, "gps"

    .line 44
    invoke-virtual {v0, v2}, Landroid/location/LocationManager;->isProviderEnabled(Ljava/lang/String;)Z

    move-result v0

    .line 45
    iget-object v2, p0, Lahmyth/mine/king/ahmyth/LocManager;->locationManager:Landroid/location/LocationManager;

    const-string v3, "network"

    invoke-virtual {v2, v3}, Landroid/location/LocationManager;->isProviderEnabled(Ljava/lang/String;)Z

    move-result v2

    if-nez v0, :cond_2

    if-nez v2, :cond_2

    const-string v0, "Location providers disabled"

    .line 48
    invoke-interface {p1, v1, v0}, Lahmyth/mine/king/ahmyth/LocManager$LocationResultCallback;->onResult(Landroid/location/Location;Ljava/lang/String;)V

    return-void

    .line 53
    :cond_2
    new-instance v1, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v3

    invoke-direct {v1, v3}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    .line 54
    new-instance v3, Lahmyth/mine/king/ahmyth/-$$Lambda$LocManager$LvnC0Tvhxz0rGUo4UOne_HJEU8c;

    invoke-direct {v3, p0, p1, v2, v0}, Lahmyth/mine/king/ahmyth/-$$Lambda$LocManager$LvnC0Tvhxz0rGUo4UOne_HJEU8c;-><init>(Lahmyth/mine/king/ahmyth/LocManager;Lahmyth/mine/king/ahmyth/LocManager$LocationResultCallback;ZZ)V

    invoke-virtual {v1, v3}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    return-void
.end method

.method public synthetic lambda$getLocationAsync$1$LocManager(Lahmyth/mine/king/ahmyth/LocManager$LocationResultCallback;ZZ)V
    .locals 6

    .line 55
    new-instance v0, Landroid/os/Handler;

    invoke-direct {v0}, Landroid/os/Handler;-><init>()V

    const/4 v1, 0x1

    new-array v1, v1, [Z

    const/4 v2, 0x0

    aput-boolean v2, v1, v2

    .line 58
    new-instance v2, Lahmyth/mine/king/ahmyth/LocManager$1;

    invoke-direct {v2, p0, v1, v0, p1}, Lahmyth/mine/king/ahmyth/LocManager$1;-><init>(Lahmyth/mine/king/ahmyth/LocManager;[ZLandroid/os/Handler;Lahmyth/mine/king/ahmyth/LocManager$LocationResultCallback;)V

    .line 73
    new-instance v3, Lahmyth/mine/king/ahmyth/-$$Lambda$LocManager$5-keEm9Zb3yYedbUrNqew-jv0yM;

    invoke-direct {v3, p0, v1, v2, p1}, Lahmyth/mine/king/ahmyth/-$$Lambda$LocManager$5-keEm9Zb3yYedbUrNqew-jv0yM;-><init>(Lahmyth/mine/king/ahmyth/LocManager;[ZLandroid/location/LocationListener;Lahmyth/mine/king/ahmyth/LocManager$LocationResultCallback;)V

    const-wide/16 v4, 0x2710

    invoke-virtual {v0, v3, v4, v5}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    const/4 v0, 0x0

    if-eqz p2, :cond_0

    .line 83
    :try_start_0
    iget-object p2, p0, Lahmyth/mine/king/ahmyth/LocManager;->locationManager:Landroid/location/LocationManager;

    const-string p3, "network"

    invoke-virtual {p2, p3, v2, v0}, Landroid/location/LocationManager;->requestSingleUpdate(Ljava/lang/String;Landroid/location/LocationListener;Landroid/os/Looper;)V

    goto :goto_2

    :catch_0
    move-exception p2

    goto :goto_0

    :catch_1
    move-exception p2

    goto :goto_1

    :cond_0
    if-eqz p3, :cond_1

    .line 85
    iget-object p2, p0, Lahmyth/mine/king/ahmyth/LocManager;->locationManager:Landroid/location/LocationManager;

    const-string p3, "gps"

    invoke-virtual {p2, p3, v2, v0}, Landroid/location/LocationManager;->requestSingleUpdate(Ljava/lang/String;Landroid/location/LocationListener;Landroid/os/Looper;)V
    :try_end_0
    .catch Ljava/lang/SecurityException; {:try_start_0 .. :try_end_0} :catch_1
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_2

    .line 90
    :goto_0
    new-instance p3, Ljava/lang/StringBuilder;

    invoke-direct {p3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Exception: "

    invoke-virtual {p3, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {p3, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-interface {p1, v0, p2}, Lahmyth/mine/king/ahmyth/LocManager$LocationResultCallback;->onResult(Landroid/location/Location;Ljava/lang/String;)V

    goto :goto_2

    .line 88
    :goto_1
    new-instance p3, Ljava/lang/StringBuilder;

    invoke-direct {p3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "SecurityException: "

    invoke-virtual {p3, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/SecurityException;->getMessage()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {p3, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-interface {p1, v0, p2}, Lahmyth/mine/king/ahmyth/LocManager$LocationResultCallback;->onResult(Landroid/location/Location;Ljava/lang/String;)V

    :cond_1
    :goto_2
    return-void
.end method

.method public synthetic lambda$null$0$LocManager([ZLandroid/location/LocationListener;Lahmyth/mine/king/ahmyth/LocManager$LocationResultCallback;)V
    .locals 2

    const/4 v0, 0x0

    .line 74
    aget-boolean v1, p1, v0

    if-nez v1, :cond_0

    const/4 v1, 0x1

    .line 75
    aput-boolean v1, p1, v0

    .line 76
    :try_start_0
    iget-object p1, p0, Lahmyth/mine/king/ahmyth/LocManager;->locationManager:Landroid/location/LocationManager;

    invoke-virtual {p1, p2}, Landroid/location/LocationManager;->removeUpdates(Landroid/location/LocationListener;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    :catch_0
    const/4 p1, 0x0

    const-string p2, "Timeout waiting for location"

    .line 77
    invoke-interface {p3, p1, p2}, Lahmyth/mine/king/ahmyth/LocManager$LocationResultCallback;->onResult(Landroid/location/Location;Ljava/lang/String;)V

    :cond_0
    return-void
.end method
