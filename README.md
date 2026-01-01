A minimal implementation of toast messages.

## Usage

The api of this package is very simple and easy to use:

```dart
// Show a toast message with an opinionated and minimal look:
context.showToastMessage(
    message: 'My message',
    toastType: ToastType.success
);

// Show a toast with custom content:
context.showToast(content: MyToastWidget());

// or if you prefer not using context extensions:
showToastMessage(context, message: 'My message', toastType: ToastType.success);
showToast(context, MyToastWidget());
```

`showToast` and `showToastMessage` have a lot of properties to customize the look, aligment and behaviour of toasts. The showToastMessage implementation uses material and is not compatible with cupertino, `showToast` should work for any design system.

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

All the properties of `ToastThemeData` with a short description are available [here](https://pub.dev/documentation/toast_messages/latest/toast_messages/ToastThemeData-class.html).

## Closing toasts

By default toasts close after a time specified by their `duration` parameter, or when the user clicks them.
It is also possible to close toasts programmatically.

```dart
// clear the queue of toasts
ToastManager.clearQueue()

// close the toast that is currently on screen if there is one.
ToastManager.dismiss()
```
