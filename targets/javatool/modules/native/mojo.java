import java.io.*;
import java.util.*;

class gxtkGraphics {

    BBJavaToolGame game;

    int width, height;

    float alpha;
    float r, g, b;
    int colorARGB;
    int blend;
    float ix, iy, jx, jy, tx, ty;
    boolean tformed;

    gxtkGraphics() {

        game = BBJavaToolGame.JavaToolGame();

        width = Integer.parseInt(MonkeyConfig.JAVATOOL_WINDOW_WIDTH);
        height = Integer.parseInt(MonkeyConfig.JAVATOOL_WINDOW_HEIGHT);
    }

    void Reset() {
    }

    void Flush() {
        Reset();
    }

    void Begin(int type, int count, gxtkSurface surf) {
    }

    // ***** GXTK API *****

    int Width() {
        return width;
    }

    int Height() {
        return height;
    }

    int BeginRender() {
        Reset();

        return 1;
    }

    void EndRender() {
        Flush();
    }

    gxtkSurface LoadSurface__UNSAFE__(gxtkSurface surface, String path) {
        BufferedImage bitmap = game.LoadBitmap(path);
        if (bitmap == null)
            return null;
        surface.SetBitmap(bitmap);
        return surface;
    }

    gxtkSurface LoadSurface(String path) {
        return LoadSurface__UNSAFE__(new gxtkSurface(), path);
    }

    gxtkSurface CreateSurface(int width, int height) {
        BufferedImage bitmap = new BufferedImage(width, height, BufferedImage.TYPE_INT_ARGB);
        if (bitmap != null)
            return new gxtkSurface(bitmap);
        return null;
    }

    void DiscardGraphics() {
    }

    int SetAlpha(float alpha) {
        this.alpha = alpha;
        int a = (int) (alpha * 255);
        colorARGB = (a << 24) | ((int) (b * alpha) << 16) | ((int) (g * alpha) << 8)
                | (int) (r * alpha);
        return 0;
    }

    int SetColor(float r, float g, float b) {
        this.r = r;
        this.g = g;
        this.b = b;
        int a = (int) (alpha * 255);
        colorARGB = (a << 24) | ((int) (b * alpha) << 16) | ((int) (g * alpha) << 8)
                | (int) (r * alpha);
        return 0;
    }

    int SetBlend(int blend) {
        if (blend == this.blend)
            return 0;

        Flush();

        this.blend = blend;

        return 0;
    }

    int SetScissor(int x, int y, int w, int h) {
        Flush();

        return 0;
    }

    int SetMatrix(float ix, float iy, float jx, float jy, float tx, float ty) {

        tformed = (ix != 1 || iy != 0 || jx != 0 || jy != 1 || tx != 0 || ty != 0);
        this.ix = ix;
        this.iy = iy;
        this.jx = jx;
        this.jy = jy;
        this.tx = tx;
        this.ty = ty;

        return 0;
    }

    int Cls(float r, float g, float b) {
        Reset();

        return 0;
    }

    int DrawPoint(float x, float y) {
        return 0;
    }

    int DrawRect(float x, float y, float w, float h) {
        return 0;
    }

    int DrawLine(float x0, float y0, float x1, float y1) {
        return 0;
    }

    int DrawOval(float x, float y, float w, float h) {
        return 0;
    }

    int DrawPoly(float[] verts) {
        return 0;
    }

    int DrawPoly2(float[] verts, gxtkSurface surface, int srcx, int srcy) {
        return 0;
    }

    int DrawSurface(gxtkSurface surface, float x, float y) {
        return 0;
    }

    int DrawSurface2(gxtkSurface surface, float x, float y, int srcx, int srcy, int srcw, int srch) {
        return 0;
    }

    int ReadPixels(int[] pixels, int x, int y, int width, int height, int offset, int pitch) {

        Flush();

        int i = 0;
        for (int py = height - 1; py >= 0; --py) {
            int j = offset + py * pitch;
            for (int px = 0; px < width; ++px) {
                pixels[j++] = 0;
            }
        }

        return 0;
    }

    int WritePixels2(gxtkSurface surface, int[] pixels, int x, int y, int width, int height,
            int offset, int pitch) {
        Flush();

        return 0;
    }

}

class gxtkSurface {

    BufferedImage bitmap;

    int width, height;

    gxtkSurface() {
    }

    gxtkSurface(BufferedImage bitmap) {
        SetBitmap(bitmap);
    }

    void SetBitmap(BufferedImage bitmap) {
        this.bitmap = bitmap;
        width = bitmap.getWidth();
        height = bitmap.getHeight();
    }

    protected void finalize() {
        Discard();
    }

    // ***** GXTK API *****

    int Discard() {
        bitmap = null;
        return 0;
    }

    int Width() {
        return width;
    }

    int Height() {
        return height;
    }

    int Loaded() {
        return 1;
    }

    boolean OnUnsafeLoadComplete() {
        return true;
    }

}

class gxtkAudio {

    static class gxtkChannel {
        int stream; // SoundPool stream ID, 0=none
        float volume = 1;
        float rate = 1;
        float pan;
        int state;
    };

    BBJavaToolGame game;
    float musicVolume = 1;
    int musicState = 0;

    gxtkChannel[] channels = new gxtkChannel[32];

    gxtkAudio() {
        game = BBJavaToolGame.JavaToolGame();
        for (int i = 0; i < 32; ++i) {
            channels[i] = new gxtkChannel();
        }
    }

    void OnDestroy() {
    }

    // ***** GXTK API *****
    int Suspend() {
        return 0;
    }

    int Resume() {
        return 0;
    }

    gxtkSample LoadSample(String path) {
        return null;
    }

    int PlaySample(gxtkSample sample, int channel, int flags) {
        gxtkChannel chan = channels[channel];
        float rv = (chan.pan * .5f + .5f) * chan.volume;
        float lv = chan.volume - rv;
        int loops = (flags & 1) != 0 ? -1 : 0;

        chan.stream = 1;
        chan.state = 1;
        return 0;
    }

    int StopChannel(int channel) {
        gxtkChannel chan = channels[channel];
        if (chan.state != 0) {
            chan.state = 0;
        }
        return 0;
    }

    int PauseChannel(int channel) {
        gxtkChannel chan = channels[channel];
        if (chan.state == 1) {
            chan.state = 2;
        }
        return 0;
    }

    int ResumeChannel(int channel) {
        gxtkChannel chan = channels[channel];
        if (chan.state == 2) {
            chan.state = 1;
        }
        return 0;
    }

    int ChannelState(int channel) {
        return -1;
    }

    int SetVolume(int channel, float volume) {
        gxtkChannel chan = channels[channel];
        chan.volume = volume;
        return 0;
    }

    int SetPan(int channel, float pan) {
        gxtkChannel chan = channels[channel];
        chan.pan = pan;
        return 0;
    }

    int SetRate(int channel, float rate) {
        gxtkChannel chan = channels[channel];
        chan.rate = rate;
        return 0;
    }

    int PlayMusic(String path, int flags) {
        musicState = 1;
        return 0;
    }

    int StopMusic() {
        musicState = 0;
        return 0;
    }

    int PauseMusic() {
        musicState = 2;
        return 0;
    }

    int ResumeMusic() {
        musicState = 1;
        return 0;
    }

    int MusicState() {
        return musicState;
    }

    int SetMusicVolume(float volume) {
        musicVolume = volume;
        return 0;
    }
}

class gxtkSample {

    int sound;

    gxtkSample() {
    }

    gxtkSample(int sound) {
        this.sound = sound;
    }

    void SetSound(int sound) {
        this.sound = sound;
    }

    protected void finalize() {
        Discard();
    }

    // ***** GXTK API *****

    int Discard() {
        return 0;
    }
}
