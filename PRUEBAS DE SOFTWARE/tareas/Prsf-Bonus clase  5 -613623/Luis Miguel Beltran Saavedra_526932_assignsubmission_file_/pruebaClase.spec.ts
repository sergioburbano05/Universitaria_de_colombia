import { test, expect } from '@playwright/test';

test('mi primera prueba', async ({ page }) => {
  await page.goto('https://demo.playwright.dev/todomvc');
  await page.screenshot({ path: 'inicioPrueba.png' });
});

test('Navegar, Localizar y Hacer Assertions', async ({ page }) => {
  await page.goto('https://demo.playwright.dev/todomvc');
  await page.getByPlaceholder('What needs to be done?').fill('Nueva clase');
  await page.getByPlaceholder('What needs to be done?').press('Enter');
  await page.screenshot({ path: 'localizar.png' });
  await page.getByPlaceholder('What needs to be done?').fill('Nueva clase 2');
  await page.getByPlaceholder('What needs to be done?').press('Enter');
  await page.screenshot({ path: 'localizar2.png' });
  await page.getByPlaceholder('What needs to be done?').fill('Nueva clase 3');
  await page.getByPlaceholder('What needs to be done?').press('Enter');
  await page.screenshot({ path: 'localizar3.png' });
});

test('tarea completada', async ({ page }) => {
  await page.goto('https://demo.playwright.dev/todomvc');
  await page.getByPlaceholder('What needs to be done?').fill('Nueva clase');
  await page.getByPlaceholder('What needs to be done?').press('Enter');

  const tarea = page.locator('div.view', { hasText: 'nueva' });
  await tarea.locator('input.toggle').check();
  await page.screenshot({ path: 'tareaCompletada.png' });

});

test('filtro', async ({ page }) => {
    await page.goto('https://demo.playwright.dev/todomvc');
    await page.getByPlaceholder('What needs to be done?').fill('Nueva clase');
    await page.getByPlaceholder('What needs to be done?').press('Enter');
    await page.locator('#toggle-all').check();
    await page.screenshot({ path: 'filtro.png' });
});

test(' limpiar localStorage y recargar la página', async ({ page }) => {
  await page.goto('https://demo.playwright.dev/todomvc');
  await page.getByPlaceholder('What needs to be done?').fill('Estudiar Playwright');
  await page.getByPlaceholder('What needs to be done?').press('Enter');
  await page.screenshot({ path: 'localizar.png' });
  await page.getByPlaceholder('What needs to be done?').fill('Hacer ejercicio E2E');
  await page.getByPlaceholder('What needs to be done?').press('Enter');
  await page.screenshot({ path: 'localizar2.png' });
  await page.getByPlaceholder('What needs to be done?').fill('Repasar POM');
  await page.getByPlaceholder('What needs to be done?').press('Enter');
    await page.evaluate(() => localStorage.clear());
    await page.reload();
    await page.screenshot({ path: 'limpiarLocalStorage.png' });
});


test('eliminar tarea', async ({ page }) => {
  await page.goto('https://demo.playwright.dev/todomvc');
    await page.getByPlaceholder('What needs to be done?').fill('nueva tarea');
    await page.getByPlaceholder('What needs to be done?').press('Enter');


  const tarea = page.getByTestId('todo-item').filter({ hasText: 'nueva tarea' });

  await tarea.hover(); // mostrar botón
  await tarea.locator('.destroy').click();

  await expect(tarea).toHaveCount(0);
  await page.screenshot({ path: 'eliminarTarea.png' });
});



