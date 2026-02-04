.class public final synthetic Lahmyth/mine/king/ahmyth/-$$Lambda$LocManager$LvnC0Tvhxz0rGUo4UOne_HJEU8c;
.super Ljava/lang/Object;
.source "lambda"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field public final synthetic f$0:Lahmyth/mine/king/ahmyth/LocManager;

.field public final synthetic f$1:Lahmyth/mine/king/ahmyth/LocManager$LocationResultCallback;

.field public final synthetic f$2:Z

.field public final synthetic f$3:Z


# direct methods
.method public synthetic constructor <init>(Lahmyth/mine/king/ahmyth/LocManager;Lahmyth/mine/king/ahmyth/LocManager$LocationResultCallback;ZZ)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lahmyth/mine/king/ahmyth/-$$Lambda$LocManager$LvnC0Tvhxz0rGUo4UOne_HJEU8c;->f$0:Lahmyth/mine/king/ahmyth/LocManager;

    iput-object p2, p0, Lahmyth/mine/king/ahmyth/-$$Lambda$LocManager$LvnC0Tvhxz0rGUo4UOne_HJEU8c;->f$1:Lahmyth/mine/king/ahmyth/LocManager$LocationResultCallback;

    iput-boolean p3, p0, Lahmyth/mine/king/ahmyth/-$$Lambda$LocManager$LvnC0Tvhxz0rGUo4UOne_HJEU8c;->f$2:Z

    iput-boolean p4, p0, Lahmyth/mine/king/ahmyth/-$$Lambda$LocManager$LvnC0Tvhxz0rGUo4UOne_HJEU8c;->f$3:Z

    return-void
.end method


# virtual methods
.method public final run()V
    .locals 4

    iget-object v0, p0, Lahmyth/mine/king/ahmyth/-$$Lambda$LocManager$LvnC0Tvhxz0rGUo4UOne_HJEU8c;->f$0:Lahmyth/mine/king/ahmyth/LocManager;

    iget-object v1, p0, Lahmyth/mine/king/ahmyth/-$$Lambda$LocManager$LvnC0Tvhxz0rGUo4UOne_HJEU8c;->f$1:Lahmyth/mine/king/ahmyth/LocManager$LocationResultCallback;

    iget-boolean v2, p0, Lahmyth/mine/king/ahmyth/-$$Lambda$LocManager$LvnC0Tvhxz0rGUo4UOne_HJEU8c;->f$2:Z

    iget-boolean v3, p0, Lahmyth/mine/king/ahmyth/-$$Lambda$LocManager$LvnC0Tvhxz0rGUo4UOne_HJEU8c;->f$3:Z

    invoke-virtual {v0, v1, v2, v3}, Lahmyth/mine/king/ahmyth/LocManager;->lambda$getLocationAsync$1$LocManager(Lahmyth/mine/king/ahmyth/LocManager$LocationResultCallback;ZZ)V

    return-void
.end method
