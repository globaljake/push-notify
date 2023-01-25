export default {
  start: (_app) => {
    customElements.define(
      "push-notify-ui-time",
      class extends HTMLElement {
        constructor() {
          super();

          this._posix = this.posix || null;
          delete this.posix;
        }

        set posix(value) {
          if (value === this._posix) return;
          this._posix = value;
          this.render();
        }

        connectedCallback() {
          this.render();
        }

        render() {
          switch (this.format) {
            case "date": {
              this.textContent = new Date(this._posix).toLocaleDateString(
                undefined,
                {
                  month: "2-digit",
                  day: "2-digit",
                }
              );
              break;
            }

            case "full-date": {
              this.textContent = new Date(this._posix).toLocaleDateString(
                undefined,
                {
                  year: "2-digit",
                  month: "2-digit",
                  day: "2-digit",
                }
              );
              break;
            }

            case "short-month": {
              this.textContent = new Date(this._posix).toLocaleDateString(
                undefined,
                {
                  month: "short",
                  year: "numeric",
                }
              );
              break;
            }

            case "month": {
              this.textContent = new Date(this._posix).toLocaleDateString(
                undefined,
                {
                  month: "long",
                }
              );
              break;
            }

            case "day": {
              this.textContent = new Date(this._posix).toLocaleDateString(
                undefined,
                {
                  month: "long",
                  day: "numeric",
                }
              );
              break;
            }

            case "full-day": {
              this.textContent = new Date(this._posix).toLocaleDateString(
                undefined,
                {
                  month: "long",
                  year: "numeric",
                  day: "numeric",
                }
              );
              break;
            }

            case "short-day": {
              this.textContent = new Date(this._posix).toLocaleDateString(
                undefined,
                {
                  month: "short",
                  day: "numeric",
                }
              );
              break;
            }

            case "weekday": {
              this.textContent = new Date(this._posix).toLocaleDateString(
                undefined,
                {
                  weekday: "long",
                  month: "long",
                  day: "numeric",
                }
              );
              break;
            }

            case "time": {
              this.textContent = new Date(this._posix).toLocaleTimeString(
                undefined,
                {
                  hour: "2-digit",
                  minute: "2-digit",
                }
              );
              break;
            }

            case "datetime": {
              this.textContent = new Date(this._posix).toLocaleTimeString(
                undefined,
                {
                  month: "2-digit",
                  day: "2-digit",
                  year: "numeric",
                  hour: "numeric",
                  minute: "2-digit",
                }
              );
              break;
            }

            case "days-until": {
              const difference = new Date(this._posix) - new Date();
              const dayDivisor = 1000 * 3600 * 24;
              this.textContent = Math.ceil(difference / dayDivisor);
              break;
            }
          }
        }
      }
    );
  },
};
