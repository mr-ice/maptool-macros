import datetime
import zipfile

def print_info(archive_name):
    create_system = { '0': 'Windows', '3': 'Unix' }
    print("Archive: " + archive_name)
    zf = zipfile.ZipFile(archive_name)
    sum = 0
    count = 0
    print("  Length     Date     Time       Name")
    print("---------  ---------- --------   ----")
    for info in zf.infolist():
        print("%9s  %15s   %s"%(info.file_size, datetime.datetime(*info.date_time), info.filename))
        sum += info.file_size
        count += 1

    print("---------                        ----")
    print("%9s                        %s files"%(sum, count))
