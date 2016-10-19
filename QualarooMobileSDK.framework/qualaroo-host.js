//
//  qualaroo-host.js
//  QualarooMobileSDK
//
//  Created by Ruben Nine on 18/03/16.
//  Copyright © 2016 Qualaroo. All rights reserved.
//

var QualarooHost = function() {};
var isVertical = false;
var isScrolled = false;

QualarooHost.prototype = {

    handleGlobalErrorEvent: function(e) {
        if (e.target instanceof HTMLScriptElement) {
            var scriptElement = e.target;
            var badProtocolRegExp = /(http|file)\:/;

            // Fix any script URLs using http or file protocol
            if (scriptElement.src.match(badProtocolRegExp) != null) {
                var fixedSrc = scriptElement.src.replace(badProtocolRegExp, "https:");
                scriptElement.src = fixedSrc;
            } else {
                // Any script URLs that failed loading not due to a bad protocol
                // that are used by KISpock's `sendReport` should be stored and
                // re-sent whenever network connectivity is back on.
                var url = new URL(scriptElement.src);

                if (url.pathname.match(/\/[r|a|s|c]\.js$/) != null) {
                    window.webkit.messageHandlers.surveyUndeliveredAnswerRequest.postMessage(scriptElement.src);
                }
            }
        } else {
            window.webkit.messageHandlers.globalUnhandledJSError.postMessage("Unhandled error in element " + e.target);
        }
    },

    loadQualarooScript: function(url, onLoadCallback, onErrorCallback) {
        var head = document.getElementsByTagName("head")[0];

        if (head) {
            var existingScript = document.getElementById("qualarooScript");

            if (existingScript) {
                head.removeChild(existingScript);
            }

            // Let's add it
            var script = document.createElement("script");

            script.addEventListener('load', onLoadCallback);
            script.addEventListener('error', onErrorCallback);

            script.id = "qualarooScript";
            script.src = url;
            script.type = "text/javascript";
            script.async = true;

            head.appendChild(script);
        }
    },

    disableCustomStyles: function() {
        [].slice.call(document.styleSheets).forEach(function (sheet) {
            if (sheet.ownerNode.id.match(/^qual_/) != null) {
                sheet.ownerNode.remove();
            }
        });
    },

    loadStylesheetIfNotAlreadyLoaded: function(relativeURL, onLoadCallback) {
        // Find the head
        var head = document.getElementsByTagName("head")[0];

        if (head) {
            var links = head.getElementsByTagName("link");
            var linksArray = Array.prototype.slice.call(links);

            // Check if stylesheet is already present
            for (link of linksArray) {
                if (link.href.split("/").pop() == relativeURL) {
                    // Already there; return early and call callback
                    onLoadCallback();
                    return;
                }
            }

            // Not found. Let's add it
            var link = document.createElement("link");

            link.addEventListener('load', onLoadCallback);
            link.href = relativeURL;
            link.type = "text/css";
            link.rel = "stylesheet";
            link.media = "all";

            head.appendChild(link);
        }
    },

    loadThemeStylesheetBasedOnBackgroundInElement: function(elementID, onLoadCallback) {
        this._removeStylesheet("qualaroo-lightui-custom.css");
        this._removeStylesheet("qualaroo-darkui-custom.css");

        if (this._isLightTheme(elementID)) {
            this.loadStylesheetIfNotAlreadyLoaded("qualaroo-lightui-custom.css", onLoadCallback);
        } else {
            this.loadStylesheetIfNotAlreadyLoaded("qualaroo-darkui-custom.css", onLoadCallback);
        }
    },

    // Temporary workaround until our JS library uses https:// internally
    removeBaseURL: function() {
        var head = document.getElementsByTagName("head")[0];

        if (head) {
            var base = head.getElementsByTagName("base")[0];

            if (base) {
                head.removeChild(base);
            }
        }
    },

    // Temporary workaround until our JS library uses https:// internally
    setBaseURLToHTTPS: function() {
        var head = document.getElementsByTagName("head")[0];

        if (head) {
            var base = head.getElementsByTagName("base")[0];

            if (!base) {
                base = document.createElement("base");
                head.appendChild(base);
            }

            base.href = "https://localhost";
        }
    },

    // Temporary workaround until our JS library uses https:// internally
    forceHTTPSinBackgroundURL: function(elementClassName) {
        var scrnr_logo = document.getElementsByClassName(elementClassName)[0];

        if (scrnr_logo) {
            var newBackgroundImage = window.getComputedStyle(scrnr_logo).backgroundImage.replace(/(http|file)\:/, "https:");
            scrnr_logo.style.backgroundImage = newBackgroundImage;
        }
    },

    addEventListenerOnCloseButton: function() {
        var xClose = document.getElementsByClassName("qual_x_close")[0];

        if (xClose) {
            xClose.addEventListener("click", function(event) {
                setTimeout(function() {
                    var ol = document.getElementById("qual_ol");

                    if (ol) {
                        // is there a better way to determine minimize state?
                        var isMinimized = ol.style.height == "10px";

                        window.webkit.messageHandlers.surveyCloseButtonTapped.postMessage(isMinimized);
                    }
                }, 50);
            });
        }
    },
    addOnClickItems: function () {
      var itemsList = document.getElementsByClassName("qual_ol_ans_item");
      var items = Array.prototype.slice.call(itemsList);

      if (items.length != 0) {
        for (item of items) {
            if (item.onclick) return;
            item.onclick = function(event) {
                event.target.scrollIntoView();
            }
        }
      }
    },
    demoScroll: function () {
      var box = document.getElementById("qual_ol_box");
      if (box && isVertical && !isScrolled) {
        window.webkit.messageHandlers.startDemoScroll.postMessage('');
        setTimeout(function() {
            function scrollDown(element, to, duration) {

              var difference = to - element.scrollTop;
              var perTick = difference / duration * 10;

              if (difference - perTick <= box.offsetHeight) return;
              setTimeout(function() {
                element.scrollTop = element.scrollTop + perTick;
                if (element.scrollTop == 0) return;
                scrollDown(element, to, duration - 10);
              }, 10);
            }
            scrollDown(box, suggestedNewHeight, 2000);
            setTimeout(function() {
                function scrollTo(element, to, duration) {

                    var difference = to - element.scrollTop;
                    var perTick = difference / duration * 10;

                    if (duration <= 0) return;
                    setTimeout(function() {
                        element.scrollTop = element.scrollTop + perTick;
                        if (element.scrollTop == to) {
                            window.webkit.messageHandlers.stopDemoScroll.postMessage('');
                            isScrolled = true;
                            return;
                        }
                        scrollTo(element, to, duration - 10);
                    }, 10);
                }
            scrollTo(box, 0, 1000);
            }, 2010);
        }, 800);
      }
    },

    calculateCurrentHeight: function() {
        var ol = document.getElementById("qual_ol");

        if (ol) {
            return ol.offsetHeight;
        }
    },

    calculateSuggestedHeight: function() {
        var ol = document.getElementById("qual_ol");
        var olBox = document.getElementById("qual_ol_box");
        var olStuff = document.getElementById("qual_ol_stuff");

        if (ol && olBox && olStuff) {
            suggestedNewHeight = ol.offsetHeight + (olStuff.offsetHeight - olBox.offsetHeight);
            return suggestedNewHeight;
        }
    },

    reflowAnswers: function() {
        var ansBox = document.getElementById("qual_ol_ans_box");

        if (ansBox) {
            var ansItemsList = ansBox.getElementsByClassName("qual_ol_ans_item");
            var ansItems = Array.prototype.slice.call(ansItemsList);

            for (item of ansItems) {
               // As soon as we find an item that does not fit inside its intended space,
               // we change the answers arrangement to vertical.
               if (isVertical) break;
               if (item.scrollWidth > item.offsetWidth) {
                    // arrange items vertically
                    ansBox.classList.add("vertical-arrangement");
                    isVertical = true;
                    // break the loop early
                    break;
                } else {
                    if (ansBox.classList.contains("vertical-arrangement")) {
                        ansBox.classList.remove("vertical-arrangement");
                    }
                }
            }
        }
    },

    hideLogoIfCheckIsPresent: function() {
        var logo = document.getElementsByClassName("qual_ol_logo")[0];

        if (!logo) {
            return;
        }

        var check = document.getElementsByClassName("qual_ol_check")[0];

        if (check) {
            logo.style.display = "none";
        } else {
            logo.style.display = "block";
        }
    },

    notifySurveyHeightChangedIfNeeded: function() {
        var currentHeight = this.calculateCurrentHeight();

        if (currentHeight != undefined) {
            var suggestedHeight = this.calculateSuggestedHeight();

            if (currentHeight != suggestedHeight && suggestedHeight > 0) {
                window.webkit.messageHandlers.surveyHeightChanged.postMessage(suggestedHeight);
            }
        }
    },

    notifySurveyHeightChangedForScreenerIfNeeded: function() {
        var screener = document.getElementById("qual_scrnr");

        if (screener) {
            var currentHeight = document.body.offsetHeight;
            var suggestedHeight = screener.offsetHeight;

            if (currentHeight != suggestedHeight && suggestedHeight > 0) {
                window.webkit.messageHandlers.surveyHeightChanged.postMessage(suggestedHeight);
            }
        }
    },

    notifySurveyScreenerReady: function() {
        window.webkit.messageHandlers.surveyScreenerReady.postMessage('');
    },

    notifySurveyShow: function() {
        window.webkit.messageHandlers.surveyShow.postMessage('');
    },

    notifySurveyClosed: function() {
        isVertical = false;
        isScrolled = false;
        window.webkit.messageHandlers.surveyClosed.postMessage('');
    },

    // Internal Functions

    _removeStylesheet: function(relativeURL) {
        // Find the head
        var head = document.getElementsByTagName("head")[0];

        if (head) {
            var links = head.getElementsByTagName("link");
            var linksArray = Array.prototype.slice.call(links);

            // Check if stylesheet is already present
            for (link of linksArray) {
                if (link.href.split("/").pop() == relativeURL) {
                    head.removeChild(link);
                }
            }
        }
    },

    _isLightTheme: function(elementID) {
        var el = document.getElementById(elementID);
        var isLight = false;

        if (el) {
            var computedBackgroundColor = window.getComputedStyle(el).backgroundColor;
            var rgb = this._parseRGBColor(computedBackgroundColor);

            if (rgb) {
                isLight = this._lumaForRGB(rgb) >= 0.5;
            }
        }

        return isLight;
    },

    _parseRGBColor: function(colorString) {
        m = colorString.match(/^rgb\s*\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*\)$/i);

        if (m) {
            return [parseFloat(m[1]), parseFloat(m[2]), parseFloat(m[3])];
        }
    },

    // Please notice the luma index is normalized into the 0..1 range,
    // whether as the input RGB components are expected to be in the 0..255 range.
    _lumaForRGB: function(rgb) {
        return (rgb[0] / 255.0) * 0.2126 +
               (rgb[1] / 255.0) * 0.7152 +
               (rgb[2] / 255.0) * 0.0722;
    }
};
