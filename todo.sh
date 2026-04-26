#!/bin/bash

rg "todo!\(\)|unimplemented!\(\)" --iglob="!todo.sh"
rg "TODO|XXX|HACK|PERF|FIXME|BUG" --iglob="!todo.sh"
