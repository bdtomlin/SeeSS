var gOverride = {
  gColor: '#EEEEEE',
  gColumns: 12,
  gOpacity: 0.35,
  gWidth: 10,
  pColor: '#000',
  pHeight: 22,
  pOffset: 0,
  pOpacity: 0.55,
  center: true,
  gEnabled: false,
  pEnabled: true,
  setupEnabled: true,
  fixFlash: true,
  size: 960
};

createGridder = function() {
  document.body.appendChild(document.createElement('script')).src='/javascripts/960.js';
};
window.onload=function(){
 createGridder();
};
