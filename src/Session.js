const STORAGE_KEY = "push-notify-store";

export default {
  start(app) {
    if (!app.ports?.sessionOutgoingMessage) return;
    app.ports.sessionOutgoingMessage.subscribe((val) => {
      if (val === null) {
        localStorage.removeItem(STORAGE_KEY);
      } else {
        localStorage.setItem(STORAGE_KEY, JSON.stringify(val));
      }
    });
  },
};
