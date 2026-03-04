.class public final synthetic Lahmyth/mine/king/ahmyth/-$$Lambda$ScreenshotManager$uRfAKktB2QOU2NG05MwZT1Nu3iA;
.super Ljava/lang/Object;
.source "lambda"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field public final synthetic f$0:Lahmyth/mine/king/ahmyth/ScreenshotManager;

.field public final synthetic f$1:Lahmyth/mine/king/ahmyth/ScreenshotManager$ScreenshotCallback;


# direct methods
.method public synthetic constructor <init>(Lahmyth/mine/king/ahmyth/ScreenshotManager;Lahmyth/mine/king/ahmyth/ScreenshotManager$ScreenshotCallback;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lahmyth/mine/king/ahmyth/-$$Lambda$ScreenshotManager$uRfAKktB2QOU2NG05MwZT1Nu3iA;->f$0:Lahmyth/mine/king/ahmyth/ScreenshotManager;

    iput-object p2, p0, Lahmyth/mine/king/ahmyth/-$$Lambda$ScreenshotManager$uRfAKktB2QOU2NG05MwZT1Nu3iA;->f$1:Lahmyth/mine/king/ahmyth/ScreenshotManager$ScreenshotCallback;

    return-void
.end method


# virtual methods
.method public final run()V
    .locals 2

    iget-object v0, p0, Lahmyth/mine/king/ahmyth/-$$Lambda$ScreenshotManager$uRfAKktB2QOU2NG05MwZT1Nu3iA;->f$0:Lahmyth/mine/king/ahmyth/ScreenshotManager;

    iget-object v1, p0, Lahmyth/mine/king/ahmyth/-$$Lambda$ScreenshotManager$uRfAKktB2QOU2NG05MwZT1Nu3iA;->f$1:Lahmyth/mine/king/ahmyth/ScreenshotManager$ScreenshotCallback;

    invoke-virtual {v0, v1}, Lahmyth/mine/king/ahmyth/ScreenshotManager;->lambda$takeScreenshot$3$ScreenshotManager(Lahmyth/mine/king/ahmyth/ScreenshotManager$ScreenshotCallback;)V

    return-void
.end method
