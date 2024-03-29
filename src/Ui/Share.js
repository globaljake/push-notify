const getTime = () => {
  const date = new Date();
  const [hr, min, rest] = date.toLocaleTimeString().split(":");
  return `${hr}:${min} ${rest.split(" ")[1]}`;
};

export default {
  start: (_app) =>
    customElements.define(
      "push-notify-ui-share",
      class extends HTMLElement {
        constructor() {
          super();

          this._text = this.text || null;
          delete this.text;
        }

        set text(value) {
          if (value === this._text) return;
          this._text = value;
        }

        connectedCallback() {
          if (!navigator.clipboard && !navigator.share) {
            console.warn(
              "no clipboard or share functionality found on browser"
            );
            return;
          }

          const button = this.querySelector("button");
          button.addEventListener("click", () => {
            if (this._text) {
              const baseMessage = this._text.replace("[TIME]", getTime());
              const message = `${baseMessage}\n\nhttps://push-notify.globaljake.com.`;

              try {
                navigator.share({ text: message }).catch(() => {
                  navigator.clipboard.writeText(message).then(() => {
                    alert("Copied to clipboard 💩");
                  });
                });
              } catch (e) {
                navigator.clipboard.writeText(message).then(() => {
                  alert("Copied to clipboard 💩");
                });
              }
            }
          });
        }

        _preloadFile() {
          fetch(this._fileUrl)
            .then((response) => response.blob())
            .then((blob) => {
              this._file = new File([blob], "super-share-card.jpg", {
                type: blob.type,
              });
            });
        }
      }
    ),
};
