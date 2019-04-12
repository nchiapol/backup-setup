#!/bin/bash
cd ~nchiapol/archive/annex || exit
git annex add ./*
git annex sync --content
git annex drop --auto
