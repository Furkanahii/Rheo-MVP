
if (!window.pomodoro) {
  window.pomodoro = {};
}

window.pomodoro.client = 'osx';
window.pomodoro.version = '4.0';

//window.console.log = function(str) {
//    window.alert("webview::" + str);
//}

window.pomodoro.purchase = function(info) {
    webkit.messageHandlers.purchase.postMessage(info);
};

window.pomodoro.openURL = function(url) {
    webkit.messageHandlers.openURL.postMessage(url);
};

window.pomodoro.playAudio = function(name) {
    webkit.messageHandlers.playAudio.postMessage(name);
}

window.pomodoro.rate = function() {
    webkit.messageHandlers.rate.postMessage("");
};

window.pomodoro.postNotification = function(notification) {
    webkit.messageHandlers.postNotification.postMessage(notification);
};

window.pomodoro.timerStateDidChange = function(stateInfo) {
    webkit.messageHandlers.timerStateDidChange.postMessage(stateInfo);
}

window.pomodoro.saveCookies = function() {
    webkit.messageHandlers.saveCookies.postMessage("");
}

window.pomodoro.switchDarkMode = function(mode) {
    webkit.messageHandlers.switchDarkMode.postMessage(mode);
};
