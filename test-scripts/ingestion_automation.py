import subprocess
import time


timeStr=time.strftime("%Y-%m-%d-%H.%M.%S")
subprocess.call('RD /S /Q "../allure-results"', shell=True)
subprocess.call("py.test --tb=line --html=../pytest-html-reports/"+timeStr+"-AutomationIngestion.html --self-contained-html  ../test-scripts/test_suite.py --alluredir ../allure-results", shell=True)
subprocess.call("allure generate --clean ../allure-results -o ../allure-reports/"+timeStr+"-allure-report", shell=True)
process = subprocess.Popen("allure open ../allure-reports/"+timeStr+"-allure-report", shell=True)
# process = subprocess.Popen("allure serve ./allure-results", shell=True)
# time.sleep(10)
# process.send_signal(signal.CTRL_C_EVENT)









