.class public final synthetic Lahmyth/mine/king/ahmyth/-$$Lambda$ScreenshotManager$sBQENDu7elzqTXcyQdJXYhKNc-U;
.super Ljava/lang/Object;
.source "lambda"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field public final synthetic f$0:Lahmyth/mine/king/ahmyth/ScreenshotManager$ScreenshotCallback;

.field public final synthetic f$1:Ljava/lang/Exception;


# direct methods
.method public synthetic constructor <init>(Lahmyth/mine/king/ahmyth/ScreenshotManager$ScreenshotCallback;Ljava/lang/Exception;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lahmyth/mine/king/ahmyth/-$$Lambda$ScreenshotManager$sBQENDu7elzqTXcyQdJXYhKNc-U;->f$0:Lahmyth/mine/king/ahmyth/ScreenshotManager$ScreenshotCallback;

    iput-object p2, p0, Lahmyth/mine/king/ahmyth/-$$Lambda$ScreenshotManager$sBQENDu7elzqTXcyQdJXYhKNc-U;->f$1:Ljava/lang/Exception;

    return-void
.end method


# virtual methods
.method public final run()V
    .locals 2

    iget-object v0, p0, Lahmyth/mine/king/ahmyth/-$$Lambda$ScreenshotManager$sBQENDu7elzqTXcyQdJXYhKNc-U;->f$0:Lahmyth/mine/king/ahmyth/ScreenshotManager$ScreenshotCallback;

    iget-object v1, p0, Lahmyth/mine/king/ahmyth/-$$Lambda$ScreenshotManager$sBQENDu7elzqTXcyQdJXYhKNc-U;->f$1:Ljava/lang/Exception;

    invoke-static {v0, v1}, Lahmyth/mine/king/ahmyth/ScreenshotManager;->lambda$null$2(Lahmyth/mine/king/ahmyth/ScreenshotManager$ScreenshotCallback;Ljava/lang/Exception;)V

    return-void
.end method
