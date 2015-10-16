#!/usr/bin/python

import sys
import Geohash
print  Geohash.encode(round(float(sys.argv[1]),6),round(float(sys.argv[2]),6),precision=12)
