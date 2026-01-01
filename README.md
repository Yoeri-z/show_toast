A minimal implementation of toast messages.

## Usage

The api of this package is very simple and easy to use:

```dart
// Show a toast with any widget content:
context.showToast(content: MyToastWidget());

// Show a toast message with an opinionated and minimal look
// fitting with material design by default.
context.showToastMessage(
    message: 'My message',
    toastType: ToastType.success
);


// or if you prefer not using context extensions:
showToast(context, MyToastWidget());
showToastMessage(
    context,
    message: 'My message',
    toastType: ToastType.success
);
```

`showToast` and `showToastMessage` have a lot of properties to customize the look, aligment and behaviour of toasts.

## Theming

If you want to customize the theme of all toasts in your app you can optionally wrap the widget tree with a ToastTheme.

```dart
ToastTheme(
    data: ToastThemeData(
        ...
    ),
    child: MyApp(),
)
```

All the properties of `ToastThemeData` with a short description are available [here](https://pub.dev/documentation/show_toast/latest/show_toast/ToastThemeData-class.html).

## Closing toasts

By default toasts close after a time specified by their `duration` parameter, or when the user clicks them.
It is also possible to close toasts programmatically.

```dart
// clear the queue of toasts
ToastManager.clearQueue()

// close the toast that is currently on screen if there is one.
ToastManager.dismiss()
```

## Animations

This package comes with three prebuilt toast animations.

```
context.showToast(
    content: MyToastWidget(),
    //toast scales up and fades in
    //this is the default animation
    animation: ScaleAnimation(),
)

context.showToast(
    content: MyToastWidget(),
    //toast fades in and out
    animation: FadeAnimation()
);

context.showToast(
    content: MyToastWWidget(),
    //toast slides in from a direction based on its alignment
    animation: SlideAnimation(),
)
```

To make your own animation you can extend and implement the `ToastAnimation` abstract class.
