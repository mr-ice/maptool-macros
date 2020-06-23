import datetime
import zipfile


def print_info(archive_name):
    print("Archive: " + archive_name)
    zf = zipfile.ZipFile(archive_name)
    sum = 0
    count = 0
    print("  Length     Date     Time       Name")
    print("---------  ---------- --------   ----")
    for info in zf.infolist():
        print("{:>9} {:>15} {}".format(
            info.file_size,
            datetime.datetime(*info.date_time),
            info.filename))
        sum += info.file_size
        count += 1

    print("---------                        ----")
    print("{:>9}                        {} files".format(sum, count))
