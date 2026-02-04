.class public final synthetic Lahmyth/mine/king/ahmyth/-$$Lambda$MainActivity$EaWcqt2mHVEbSK5hTgTZJwgU6Pw;
.super Ljava/lang/Object;
.source "lambda"

# interfaces
.implements Landroid/widget/CompoundButton$OnCheckedChangeListener;


# instance fields
.field public final synthetic f$0:Lahmyth/mine/king/ahmyth/MainActivity;

.field public final synthetic f$1:Landroid/content/SharedPreferences$Editor;


# direct methods
.method public synthetic constructor <init>(Lahmyth/mine/king/ahmyth/MainActivity;Landroid/content/SharedPreferences$Editor;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lahmyth/mine/king/ahmyth/-$$Lambda$MainActivity$EaWcqt2mHVEbSK5hTgTZJwgU6Pw;->f$0:Lahmyth/mine/king/ahmyth/MainActivity;

    iput-object p2, p0, Lahmyth/mine/king/ahmyth/-$$Lambda$MainActivity$EaWcqt2mHVEbSK5hTgTZJwgU6Pw;->f$1:Landroid/content/SharedPreferences$Editor;

    return-void
.end method


# virtual methods
.method public final onCheckedChanged(Landroid/widget/CompoundButton;Z)V
    .locals 2

    iget-object v0, p0, Lahmyth/mine/king/ahmyth/-$$Lambda$MainActivity$EaWcqt2mHVEbSK5hTgTZJwgU6Pw;->f$0:Lahmyth/mine/king/ahmyth/MainActivity;

    iget-object v1, p0, Lahmyth/mine/king/ahmyth/-$$Lambda$MainActivity$EaWcqt2mHVEbSK5hTgTZJwgU6Pw;->f$1:Landroid/content/SharedPreferences$Editor;

    invoke-virtual {v0, v1, p1, p2}, Lahmyth/mine/king/ahmyth/MainActivity;->lambda$onCreate$0$MainActivity(Landroid/content/SharedPreferences$Editor;Landroid/widget/CompoundButton;Z)V

    return-void
.end method
