# amidihub - ALSA MIDI hubconnect daemon.
# Copyright (C) 2019  Vilniaus Blokas UAB, https://blokas.io/
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; version 2 of the
# License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#

BINARY_DIR ?= /usr/local/bin

all: amidihub

# O0 is needed for the raspi
CXXFLAGS ?= -O0
LDFLAGS ?= -lasound

CXX?=g++-4.9

amidihub: amidihub.o
	$(CXX) $^ -o $@ $(LDFLAGS)
	strip $@

%.o: %.cpp
	$(CXX) -c $(CXXFLAGS) $^ -o $@

install: all
	@systemctl stop amidihub > /dev/null 2>&1 || true
	@cp -p amidihub $(BINARY_DIR)/
	@cp -p amidihub.service /usr/lib/systemd/system/
	@systemctl daemon-reload > /dev/null 2>&1
	@systemctl enable amidihub > /dev/null 2>&1
	@systemctl start amidihub > /dev/null 2>&1

clean:
	rm -f amidihub *.o
	rm -f amidihub.deb
	gunzip `find . | grep gz` > /dev/null 2>&1 || true
