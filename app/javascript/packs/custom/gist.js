// from 'Embeded Gists' article by Joseph Ndungu,
// https://josephndungu.com/tutorials/using-github-embedded-gists-with-turbolinks

var loadGist, loadGists;

$(function() {
  loadGists();
  return $(document).on('turbolinks:load', loadGists);
});

loadGists = function() {
  return $('.gist').each(function() {
    return loadGist($(this));
  });
};

loadGist = function($gist) {
  var callbackName, script;
  callbackName = 'c' + Math.random().toString(36).substring(7);
  window[callbackName] = function(gistData) {
    var html;
    delete window[callbackName];
    html = '<link rel="stylesheet" href="' + encodeURI(gistData.stylesheet) + '"></link>';
    html += gistData.div;
    $gist.html(html);
    return script.parentNode.removeChild(script);
  };
  script = document.createElement('script');
  script.setAttribute('src', [
    $gist.data('src'), $.param({
      callback: callbackName,
      file: $gist.data('file') || ''
    })
  ].join('?'));
  return document.body.appendChild(script);
};
