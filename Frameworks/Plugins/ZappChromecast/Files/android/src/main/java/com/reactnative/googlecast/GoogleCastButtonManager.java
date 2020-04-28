package com.reactnative.googlecast;

import android.app.Activity;
import android.content.Context;
import android.graphics.drawable.Drawable;
import android.util.AttributeSet;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.core.graphics.drawable.DrawableCompat;
import androidx.mediarouter.app.MediaRouteButton;

import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.annotations.ReactProp;
import com.google.android.gms.cast.framework.CastButtonFactory;
import com.google.android.gms.cast.framework.CastContext;
import com.google.android.gms.cast.framework.CastState;


public class GoogleCastButtonManager
        extends SimpleViewManager<MediaRouteButton> {

  private static final String REACT_CLASS = "RNGoogleCastButton";
  private Integer mColor = null;
  private static MediaRouteButton googleCastButtonManagerInstance;

  @NonNull
  @Override
  public String getName() {
    return REACT_CLASS;
  }

  @NonNull
  @Override
  public MediaRouteButton createViewInstance(@NonNull ThemedReactContext context) {
    CastContext castContext = CastContext.getSharedInstance(context);
    Activity currentActivity = context.getCurrentActivity();
    final MediaRouteButton button = new ColorableMediaRouteButton(currentActivity);
    googleCastButtonManagerInstance = button;
    CastButtonFactory.setUpMediaRouteButton(context, button);
    updateButtonState(button, castContext.getCastState());
    castContext.addCastStateListener(newState -> GoogleCastButtonManager.this.updateButtonState(button, newState));

    return button;
  }

  public static MediaRouteButton getGoogleCastButtonManagerInstance() {
    return googleCastButtonManagerInstance;
  }

  @ReactProp(name = "tintColor", customType = "Color")
  public void setTintColor(ColorableMediaRouteButton button, Integer color) {
    if (color == null)
      return;
    button.applyTint(color);
    mColor = color;
  }

  private void updateButtonState(MediaRouteButton button, int state) {
    Log.d(REACT_CLASS, "ChromeCast state changed to " + state);
  }

  // https://stackoverflow.com/a/41496796/384349
  private class ColorableMediaRouteButton extends MediaRouteButton {
    protected Drawable mRemoteIndicatorDrawable;

    public ColorableMediaRouteButton(Context context) { super(context); }

    public ColorableMediaRouteButton(Context context, AttributeSet attrs) {
      super(context, attrs);
    }

    public ColorableMediaRouteButton(Context context, AttributeSet attrs,
                                     int defStyleAttr) {
      super(context, attrs, defStyleAttr);
    }

    @Override
    public void setRemoteIndicatorDrawable(Drawable d) {
      mRemoteIndicatorDrawable = d;
      super.setRemoteIndicatorDrawable(d);
      if (mColor != null)
        applyTint(mColor);
    }

    public void applyTint(Integer color) {
      if (mRemoteIndicatorDrawable == null)
        return;

      Drawable wrapDrawable = DrawableCompat.wrap(mRemoteIndicatorDrawable);
      DrawableCompat.setTint(wrapDrawable, color);
    }
  }
}
