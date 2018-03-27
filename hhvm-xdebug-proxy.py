import socket
import thread

PROXY_PORT=10003

IDE_HOST="127.0.0.1"
IDE_PORT=9019

class XdebugReader:
  def __init__(self, s):
    self.s = s
    self.buf = ""

  def next(self):
    while self.buf.count('\0') < 2:
      self.buf += self.s.recv(4096)
    msg1, msg2, self.buf = self.buf.split('\0', 2)
    msg = msg1+'\0'+msg2+'\0'
    print "xdebug: "+msg
    return msg

class IdeReader:
  def __init__(self, s):
    self.s = s
    self.buf = ""

  def next(self):
    while self.buf.count('\0') < 1:
      self.buf += self.s.recv(4096)
    msg1, self.buf = self.buf.split('\0', 1)
    msg = msg1+'\0'
    print "ide: "+msg
    return msg

def proxy(ide, xdebug):
  xdebug_reader = XdebugReader(xdebug)
  ide_reader = IdeReader(ide)

  msg = xdebug_reader.next()
  ide.send(msg)

  while True:
    msg = ide_reader.next()
    xdebug.send(msg)

    msg = xdebug_reader.next()
    ide.send(msg)

def main():
  s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
  s.bind(('0.0.0.0', PROXY_PORT))
  s.listen(5)

  while True:
    (c, addr) = s.accept()

    p = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    p.connect((IDE_HOST, IDE_PORT))

    thread.start_new_thread(proxy, (p, c))

main()