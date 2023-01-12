from selenium import webdriver
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
import time

options = webdriver.ChromeOptions()

chrome_options = Options()



chrome_options.add_experimental_option("detach", True)
chrome_options.add_experimental_option("debuggerAddress","localhost:9222")
#driver= webdriver.Chrome(executable_path="C:\\Users\\sanjesh.ld\\Downloads\\chromedriver.exe",options=options)
driver= webdriver.Chrome(options=options,service=Service(ChromeDriverManager().install()))
driver.maximize_window() 
driver.get("https://www.abhibus.com/")
#driver.implicitly_wait(10)


