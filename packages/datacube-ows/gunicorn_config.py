# Appended to datacube_ows/gunicorn_config.py in the image.

import errno
import logging


class SocketErrorFilter(logging.Filter):
    """Log "No route to host" socket errors without the traceback."""

    def filter(self, record: logging.LogRecord) -> bool:
        error = record.exc_info[1] if record.exc_info else None
        if isinstance(error, OSError) and error.errno == errno.EHOSTUNREACH:
            record.msg = f"{record.msg} {error}"
            record.exc_info = None
        return True


def post_worker_init(worker) -> None:
    logging.getLogger("gunicorn.error").addFilter(SocketErrorFilter())
