const puppeteer = require('puppeteer');
(async () => {
  const browser = await puppeteer.launch({headless: 'new'});
  const page = await browser.newPage();
  
  await page.goto('http://localhost:8080/NexGenEsportsv2/login.jsp');
  
  const getRect = async (selector) => {
    try {
      return await page.$eval(selector, el => {
        const rect = el.getBoundingClientRect();
        return {x: rect.x, y: rect.y, width: rect.width, height: rect.height, center: rect.x + rect.width/2};
      });
    } catch(e) { return null; }
  };
  
  const viewport = await page.evaluate(() => ({ w: window.innerWidth, h: window.innerHeight }));
  
  console.log('--- LOGIN PAGE ---');
  console.log('Viewport width:', viewport.w);
  console.log('h1:', await getRect('.header h1'));
  console.log('.auth-box:', await getRect('.auth-box'));
  console.log('.content:', await getRect('.content'));
  
  await browser.close();
})();
