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
          if (!navigator.clipboard && !navigator.share) return;

          const button = this.querySelector("button");
          button.addEventListener("click", () => {
            if (this._text) {
              const message = this._text.replace("[TIME]", getTime());
              navigator.share({ text: message });
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
