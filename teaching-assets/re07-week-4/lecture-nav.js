/* Shared lecture switcher for the slide viewers.
 *
 * One copy of this file is placed in each viewer bundle by the build scripts, so
 * the list of lectures is defined once here rather than in each viewer. The
 * bundles sit as siblings under /teaching-assets/, which is what the relative
 * hrefs below assume; the Quartz preview mirrors that layout exactly.
 *
 * Only the module the reader is already in is listed. A student in an RE02
 * lecture sees the other RE02 lecture, not the CaRM topics; the Teaching page is
 * the way across to another course.
 *
 * A viewer opts in by including <div id="lecture-nav"></div> below its header.
 * The CaRM viewer additionally calls window.lectureNavSetTopic('Topic 3') as the
 * reader moves between slides, so the right topic stays marked.
 */
(function () {
  var GROUPS = [
    {
      course: 'RE02',
      items: [
        { id: 're02-week-2', label: 'Space and capital markets', href: '../re02-week-2/' },
        { id: 're02-week-8', label: 'Urban and regional growth', href: '../re02-week-8/' }
      ]
    },
    {
      course: 'RE07',
      items: [
        { id: 're07-week-1', label: '1 Introduction', href: '../re07-week-1/' },
        { id: 're07-week-2', label: '2 Institutions', href: '../re07-week-2/' },
        { id: 're07-week-3', label: '3 Private investment', href: '../re07-week-3/' },
        { id: 're07-week-4', label: '4 Financing', href: '../re07-week-4/' },
        { id: 're07-week-5', label: '5 Intermediation', href: '../re07-week-5/' },
        { id: 're07-week-6', label: '6 Performance', href: '../re07-week-6/' },
        { id: 're07-week-7', label: '7 Sustainability', href: '../re07-week-7/' }
      ]
    },
    {
      course: 'REM2',
      items: [
        { id: 'rem2-session-2', label: '2 Critical reading', href: '../rem2-session-2/' },
        { id: 'rem2-session-3', label: '3 Data issues', href: '../rem2-session-3/' },
        { id: 'rem2-session-4', label: '4 Hedonic I', href: '../rem2-session-4/' },
        { id: 'rem2-session-5', label: '5 Hedonic II', href: '../rem2-session-5/' },
        { id: 'rem2-session-6', label: '6 Time series', href: '../rem2-session-6/' }
      ]
    },
    {
      course: 'CaRM',
      items: [
        { id: 'carm-time-series', topic: 'Topic 1', label: 'Stationary series', href: '../carm-time-series/#1' },
        { id: 'carm-time-series', topic: 'Topic 2', label: 'Non-stationary series', href: '../carm-time-series/#53' },
        { id: 'carm-time-series', topic: 'Topic 3', label: 'VEC and VAR', href: '../carm-time-series/#83' },
        { id: 'carm-time-series', topic: 'Topic 4', label: 'Volatility and ARCH', href: '../carm-time-series/#110' }
      ]
    }
  ];

  var here = (location.pathname.replace(/\/[^\/]*$/, '').split('/').filter(Boolean).pop()) || '';
  var currentTopic = null;

  function build() {
    var host = document.getElementById('lecture-nav');
    if (!host) return;
    host.innerHTML = '';

    // the module this viewer belongs to, and only that one
    var mine = GROUPS.filter(function (g) {
      return g.items.some(function (it) { return it.id === here; });
    });

    mine.forEach(function (g) {
      var wrap = document.createElement('span');
      wrap.className = 'lngroup';

      g.items.forEach(function (it) {
        var onThisPage = it.id === here;
        var active = onThisPage && (!it.topic || it.topic === currentTopic);
        var node;
        if (active) {
          node = document.createElement('span');
          node.className = 'lnitem here';
          node.setAttribute('aria-current', 'page');
        } else {
          node = document.createElement('a');
          node.className = 'lnitem';
          node.href = it.href;
          // switching topic within this viewer is a jump, not a page load
          if (onThisPage && it.topic) {
            node.addEventListener('click', function (e) {
              e.preventDefault();
              location.hash = it.href.split('#')[1];
            });
          }
        }
        node.textContent = it.label;
        if (it.topic) node.title = it.topic + ', ' + it.label;
        wrap.appendChild(node);
      });
      host.appendChild(wrap);
    });

    var back = document.createElement('a');
    back.className = 'lnback';
    back.href = '../../teaching';
    back.textContent = 'All teaching';
    host.appendChild(back);
  }

  window.lectureNavSetTopic = function (t) {
    if (t === currentTopic) return;
    currentTopic = t;
    build();
  };

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', build);
  } else {
    build();
  }
})();
